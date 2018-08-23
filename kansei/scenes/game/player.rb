class Player < Sprite
  attr_accessor :direction, :max_hp, :attack_interval, :attack, :avoid_timer, :current_hp, :_draw, :fukidashi_timer, :fukidashi_image

  ATTACK_S_INTERVAL = 30
  ATTACK_M_INTERVAL = 50
  ATTACK_L_INTERVAL = 70
  AVOID_TIME = 30
  AVOID_DAMAGE = 5

  ITA_IMAGE = Image.load('images/game/ita.png')
  ATTACK_PRE1_IMAGE = Image.load('images/game/attack_pre1.png')
  ATTACK_PRE2_IMAGE = Image.load('images/game/attack_pre2.png')
  ATTACK_PRE3_IMAGE = Image.load('images/game/attack_pre3.png')
  PLAYER_NORMAL_IMAGE = Image.load('images/game/player_normal.png')
  PLAYER_ATTACK_IMAGE = Image.load('images/game/player_attack.png')
  PLAYER_AVOID_IMAGE = Image.load('images/game/player_avoid.png')

  def initialize(x, y, direction, attack_s, attack_m, attack_l, max_hp, controller)
    self.x = x
    self.y = y
    self.image = PLAYER_NORMAL_IMAGE
    @direction = direction
    @attack_s = attack_s
    @attack_m = attack_m
    @attack_l = attack_l
    @max_hp = max_hp
    @controller = controller

    @attack = 0
    @attack_interval = -60
    @_draw = false
    @avoid_timer = 0
    @current_hp = @max_hp
    @fukidashi_timer = 0
    @fukidashi_image = ITA_IMAGE

    @attack_image = { 10 => ATTACK_PRE1_IMAGE, 30 => ATTACK_PRE2_IMAGE, 60 => ATTACK_PRE3_IMAGE }
  end

  def update
    attack_move(@attack_s, ATTACK_S_INTERVAL) if @controller.press_attack1
    attack_move(@attack_m, ATTACK_M_INTERVAL) if @controller.press_attack2
    attack_move(@attack_l, ATTACK_L_INTERVAL) if @controller.press_attack3
    avoid_move(AVOID_TIME) if @controller.press_avoid

    @attack_interval -= 1
    @avoid_timer -= 1
    draw_player
    draw_fukidashi

    self.draw
    super
  end

  def attack_move(attack, attack_interval)
    @attack = attack
    @attack_interval = attack_interval
  end

  def avoid_move(attack_interval)
    return if @avoid_timer > 0
    @current_hp -= AVOID_DAMAGE
    @avoid_timer = attack_interval
  end

  def draw_fukidashi
    unless @attack == 0
      if @attack_interval == ATTACK_S_INTERVAL - 1
        @fukidashi_image = @attack_image[@attack]
        @fukidashi_timer = 30
        @fukidashi_adjust_x = 30
      elsif @attack_interval == ATTACK_M_INTERVAL - 1
        @fukidashi_image = @attack_image[@attack]
        @fukidashi_timer = 30
      elsif @attack_interval == ATTACK_L_INTERVAL - 1
        @fukidashi_image = @attack_image[@attack]
        @fukidashi_timer = 30
      end
    end

    return if @fukidashi_timer <= 0
    Window.draw(self.x - @direction * 200, self.y - PLAYER_NORMAL_IMAGE.height / 2, @fukidashi_image)
    @fukidashi_timer -= 1
  end

  def draw_player
    if @attack_interval >= 0
      self.image = PLAYER_NORMAL_IMAGE
      self.scale_x = @direction
    elsif @attack_interval > -60
      self.image = PLAYER_ATTACK_IMAGE
      self.scale_x = @direction
    elsif @avoid_timer > 0
      self.image = PLAYER_AVOID_IMAGE
      self.scale_x = @direction
    else
      self.image = PLAYER_NORMAL_IMAGE
      self.scale_x = @direction
    end
  end
end
