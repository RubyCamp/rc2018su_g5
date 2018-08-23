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
    COUNTDOWN3 = Image.load('images/game/3.png')
    COUNTDOWN2 = Image.load('images/game/2.png')
    COUNTDOWN1 = Image.load('images/game/1.png')
    FIGHT = Image.load('images/game/fight.png')
    DRAW_IMAGE = Image.load('images/game/draw.png')

    SE_FIGHT = Sound.new('se/fight.wav')
    SE_ATTACK_SMALL = Sound.new('se/attack_small.wav') 
    SE_ATTACK_MIDDLE = Sound.new('se/attack_middle.wav')
    SE_ATTACK_LARGE = Sound.new('se/attack_large.wav')
    SE_ATTACK_DRAW = Sound.new('se/attack_draw.wav')

    def initialize
      @attack = { 0 => SE_ATTACK_DRAW, 10 => SE_ATTACK_SMALL, 30 => SE_ATTACK_MIDDLE, 60 => SE_ATTACK_LARGE }

      @players = []
      @players << Player.new(155, 210, 1, 10, 30, 60, 100, Controller1.new)
      @players << Player.new(360, 210, -1, 10, 30, 60, 100, Controller2.new)
      @gauges = []
      @gauges << Gauge.new(50, 50, 257, 24, @players[0])
      @gauges << Gauge.new(Window.width - 318, 50, 257, 24, @players[1], true)
      @time_ms = 0
      @winner = 0

      @fukidashi_timer = 0
      @is_faint = false
    end

    def play
      Window.draw(0, 0, BACKGROUND)
      Window.draw(0, 0, DOHYO_IMAGE)
      if @time_ms < 240
        Window.draw_ex(150, 300, RIKISHI_IMAGE)
        Window.draw_ex(390, 300, RIKISHI_IMAGE, :scale_x=>-1)
        if @time_ms >= 0 && @time_ms < 60
          Window.draw(250, 150, COUNTDOWN3)
        elsif @time_ms >= 60 && @time_ms < 120
          Window.draw(250, 150, COUNTDOWN2)
        elsif @time_ms >= 120 && @time_ms < 180
          Window.draw(250, 150, COUNTDOWN1)
        elsif @time_ms >= 180 && @time_ms < 240
          Window.draw(250, 150, FIGHT)
          SE_FIGHT.play if @time_ms == 180
        end

        @time_ms += 1
      else
        @players.each do |player|
          player.update
        end

        @gauges.each do |gauge|
          gauge.update
        end

        player_attack
        player_avoid
        draw_fukidashi

        gameover unless @is_gameover
        check_gameover
      end
    end

    def draw_fukidashi
      return if @fukidashi_timer <= 0
      Window.draw(Window.width / 2 - DRAW_IMAGE.width / 2, 120, DRAW_IMAGE)
      @fukidashi_timer -= 1
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
          @attack[@players[0].attack].play
          @fukidashi_timer = 30
        end
      else
        if @players[0].attack_interval == -1
          unless @players[0].attack == 0
            @players[1].current_hp -= @players[0].attack.to_i
            @attack[@players[0].attack].play
            @players[1].fukidashi_image = Player::ITA_IMAGE
            @players[1].fukidashi_timer = 60
          end
          @players[0].attack = 0
          @players[0].current_hp -= @players[1].attack / 4 unless @players[1].attack == 0
          @players[1].attack = 0
        end

        if @players[1].attack_interval == -1
          unless @players[1].attack == 1
            @players[0].current_hp -= @players[1].attack.to_i
            @attack[@players[1].attack].play unless @players[1].attack == 0
            @players[0].fukidashi_image = Player::ITA_IMAGE
            @players[0].fukidashi_timer = 60
          end
          @players[1].attack = 0
          @players[1].current_hp -= @players[0].attack / 4 unless @players[0].attack == 0
          @players[0].attack = 0
        end
      end
    end

    def gameover
      @gauges.each do |gauge|
        @is_faint = true if gauge.fore_image.width <= 1
      end

      return unless @is_faint

      @winner = 1 if @players[0].current_hp <= 0
      @winner = 0 if @players[1].current_hp <= 0
    end

    def check_gameover
      is_gameover = false
      @gauges.each do |gauge|
        is_gameover = true if gauge.diff_image.width <= 1
      end

      return unless is_gameover

      Scene[:result].change_bgm
      Scene.current = :result
    end

    def player_avoid
      @players[1].attack = 0 if @players[0].avoid_timer > 0 && @players[1].interval < 30
      @players[0].attack = 0 if @players[1].avoid_timer > 0 && @players[0].interval < 30
    end

    def get_winner
      return @winner
    end
  end
end
