class Player < Sprite
  attr_accessor :x, :y, :direction, :max_hp, :current_hp, :attack_interval, :aiuti, :attack, :avoid_timer, :fukidashi_timer, :fukidashi_image

  ATTACK_S_INTERVAL = 30
  ATTACK_M_INTERVAL = 50
  ATTACK_L_INTERVAL = 70
  AVOID_TIME = 30
  AVOID_DAMAGE = 5

  ITA_IMAGE = Image.load('images/game/ita.png')
  CHUMOKU_1_IMAGE = Image.load('images/game/attack_pre1.png')
  CHUMOKU_2_IMAGE = Image.load('images/game/attack_pre2.png')
  CHUMOKU_3_IMAGE = Image.load('images/game/attack_pre3.png')
  PLAYER_NORMAL = Image.load('images/game/player_normal.png')
  PLAYER_ATTACK = Image.load('images/game/player_attack.png')
  PLAYER_AVOID = Image.load('images/game/player_avoid.png')

  def initialize(x, y, direction, atk1, atk2, atk3, max_hp, controller)
    @x = x
    @y = y
    @direction = direction
    @atk1 = atk1
    @atk2 = atk2
    @atk3 = atk3
    @max_hp = max_hp
    @controller = controller

    @current_hp = @max_hp
    @angle = angle
    @attack = 0
    @attack_interval = -60
    @aiuti = false
    @avoid_timer = 0
    @fukidashi_timer = 0
    @fukidashi_image = ITA_IMAGE

    @player_sprite = Sprite.new(@x, @y, PLAYER_NORMAL)

    @chumoku = { 10 => CHUMOKU_1_IMAGE, 30 => CHUMOKU_2_IMAGE, 60 => CHUMOKU_3_IMAGE }
    super
  end

  def update
    attack_move(@atk1, ATTACK_S_INTERVAL) if @controller.press_attack1
    attack_move(@atk2, ATTACK_M_INTERVAL) if @controller.press_attack2
    attack_move(@atk3, ATTACK_L_INTERVAL) if @controller.press_attack3
    avoid_move(AVOID_TIME) if @controller.press_avoid

    @attack_interval -= 1
    @avoid_timer -= 1
    draw_player
    change_fukidashi_img
    draw_fukidashi
    @player_sprite.draw
  end

  def draw_fukidashi
    return if @fukidashi_timer <= 0
    fx = @x - @direction * (200)
    fy = @y - PLAYER_NORMAL.height / 2
    Window.draw(fx, fy, @fukidashi_image)
    @fukidashi_timer -= 1
  end

  def attack_move(atk, attack_interval)
    @attack = atk
    @attack_interval = attack_interval
  end

  def avoid_move(attack_interval)
    return if @avoid_timer > 0
    @current_hp -= AVOID_DAMAGE
    @avoid_timer = attack_interval
  end

  def change_fukidashi_img
    unless @attack == 0
      if @attack_interval == ATTACK_S_INTERVAL - 1
        @fukidashi_image = @chumoku[@attack]
        @fukidashi_timer = 30
        @fukidashi_adjust_x = 30
      elsif @attack_interval == ATTACK_M_INTERVAL - 1
        @fukidashi_image = @chumoku[@attack]
        @fukidashi_timer = 30
      elsif @attack_interval == ATTACK_L_INTERVAL - 1
        @fukidashi_image = @chumoku[@attack]
        @fukidashi_timer = 30
      end  
    end
  end

  def draw_player
    if @attack_interval >= 0
      @player_sprite = Sprite.new(@x, @y, PLAYER_NORMAL)
      @player_sprite.scale_x = @direction
      @player_sprite.angle = @angle
    elsif @attack_interval > -60
      @player_sprite = Sprite.new(@x, @y, PLAYER_ATTACK)
      @player_sprite.scale_x = @direction
      @player_sprite.angle = @angle
    else
      if @avoid_timer > 0
        @player_sprite = Sprite.new(@x, @y, PLAYER_AVOID)
        @player_sprite.scale_x = @direction
        @player_sprite.angle = @angle  
      else
        @player_sprite = Sprite.new(@x, @y, PLAYER_NORMAL)
        @player_sprite.scale_x = @direction
        @player_sprite.angle = @angle  
      end
    end
  end
end
