require_relative 'controller'
require_relative 'controller1'
require_relative 'controller2'
require_relative 'gauge'
require_relative 'player'

module Game
  class Director
    attr_accessor :players, :player1, :player2

    case rand(3)
    when 0
      BGM = Sound.new('bgm/game1.wav')
    when 1
      BGM = Sound.new('bgm/game2.wav')
    when 2
      BGM = Sound.new('bgm/game3.wav')
    end

    BACKGROUND = Image.load('images/game/background.png')
    DOHYO_IMAGE = Image.load('images/game/dohyo.png')
    RIKISHI_IMAGE = Image.load('images/game/rikishi.png')
    COUNTDOWN3_IMAGE = Image.load('images/game/3.png')
    COUNTDOWN2_IMAGE = Image.load('images/game/2.png')
    COUNTDOWN1_IMAGE = Image.load('images/game/1.png')
    FIGHT_IMAGE = Image.load('images/game/fight.png')
    DRAW_IMAGE = Image.load('images/game/draw.png')

    FIGHT_SE = Sound.new('se/fight.wav')
    ATTACK_SMALL_SE = Sound.new('se/attack_small.wav') 
    ATTACK_MIDDLE_SE = Sound.new('se/attack_middle.wav')
    ATTACK_LARGE_SE = Sound.new('se/attack_large.wav')
    ATTACK_DRAW_SE = Sound.new('se/attack_draw.wav')

    def initialize
      @players = []
      @players << Player.new(155, 210, 1, 10, 30, 60, 100, Controller1.new)
      @players << Player.new(360, 210, -1, 10, 30, 60, 100, Controller2.new)
      @gauges = []
      @gauges << Gauge.new(50, 50, 257, 24, @players[0])
      @gauges << Gauge.new(Window.width - 318, 50, 257, 24, @players[1], true)
      @winner = 0

      @count_timer = 0
      @fukidashi_timer = 0
      @gameover_timer = 0
      @is_fainted = false
      @is_gameover = false

      @attack_se = { 0 => ATTACK_DRAW_SE, 10 => ATTACK_SMALL_SE, 30 => ATTACK_MIDDLE_SE, 60 => ATTACK_LARGE_SE }
    end

    def play
      Window.draw(0, 0, BACKGROUND)
      Window.draw(0, 0, DOHYO_IMAGE)
      if @count_timer < 240
        Window.draw_ex(150, 300, RIKISHI_IMAGE)
        Window.draw_ex(390, 300, RIKISHI_IMAGE, :scale_x=>-1)
        if @count_timer >= 0 && @count_timer < 60
          Window.draw(250, 150, COUNTDOWN3_IMAGE)
        elsif @count_timer >= 60 && @count_timer < 120
          Window.draw(250, 150, COUNTDOWN2_IMAGE)
        elsif @count_timer >= 120 && @count_timer < 180
          Window.draw(250, 150, COUNTDOWN1_IMAGE)
        elsif @count_timer >= 180 && @count_timer < 240
          Window.draw(250, 150, FIGHT_IMAGE)
          FIGHT_SE.play if @count_timer == 180
        end

        @count_timer += 1
      else
        player_attack
        player_avoid

        @players.each do |player|
          player.update
        end
        @gauges.each do |gauge|
          gauge.update
        end
        draw_fukidashi

        check_faint
        check_gameover
      end
    end

    def change_bgm
      Scene[:title].class::BGM.stop
      BGM.play
    end

    def player_attack
      diff = @players[0].attack_interval - @players[1].attack_interval
      
      if diff > -15 && diff < 15
        @players[0].attack = 0
        @players[1].attack = 0
        if @players[0].attack_interval == 1 || @players[1].attack_interval == 1
          @attack_se[@players[0].attack].play
          @fukidashi_timer = 30
        end
      else
        if @players[0].attack_interval == -1
          unless @players[0].attack == 0
            @players[1].current_hp -= @players[0].attack.to_i
            @attack_se[@players[0].attack].play
            @players[1].fukidashi_image = Player::ITA_IMAGE
            @players[1].fukidashi_timer = 60
          end
          @players[0].attack = 0
          @players[0].current_hp -= @players[1].attack / 4 unless @players[1].attack == 0
          @players[1].attack = 0
        end

        if @players[1].attack_interval == -1
          unless @players[1].attack == 0
            @players[0].current_hp -= @players[1].attack.to_i
            @attack_se[@players[1].attack].play unless @players[1].attack == 0
            @players[0].fukidashi_image = Player::ITA_IMAGE
            @players[0].fukidashi_timer = 60
          end
          @players[1].attack = 0
          @players[1].current_hp -= @players[0].attack / 4 unless @players[0].attack == 0
          @players[0].attack = 0
        end
      end
    end

    def player_avoid
      @players[1].attack = 0 if @players[0].avoid_timer > 0 && @players[1].attack_interval < 30
      @players[0].attack = 0 if @players[1].avoid_timer > 0 && @players[0].attack_interval < 30
    end

    def draw_fukidashi
      return if @fukidashi_timer <= 0
      Window.draw(Window.width / 2 - DRAW_IMAGE.width / 2, 120, DRAW_IMAGE)
      @fukidashi_timer -= 1
    end

    def check_faint
      @gauges.each do |gauge|
        @is_fainted = true if gauge.fore_image.width <= 1
      end

      return unless @is_fainted

      @winner = 1 if @players[0].current_hp <= 0
      @winner = 0 if @players[1].current_hp <= 0

      90.times do |i|
        @players[(@winner - 1).abs].angle -= 1 * @players[@winner - 1].direction if i % 4 == 0
      end
    end

    def check_gameover
      @is_gameover = false
      @gauges.each do |gauge|
        @is_gameover = true if gauge.diff_image.width <= 1
      end

      return unless @is_gameover

      Scene[:result].change_bgm
      Scene.current = :result
    end

    def get_winner
      return @winner
    end
  end
end
