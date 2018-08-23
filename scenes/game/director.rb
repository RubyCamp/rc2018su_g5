require_relative 'player'
require_relative 'controller'
require_relative 'controller1'
require_relative 'controller2'

module Game
  class Director
    attr_accessor :players, :player_hash

    case rand(3)
    when 0 then
      BGM = Sound.new('sound/game1.wav')
    when 1 then
      BGM = Sound.new('sound/game2.wav')
    when 2 then
      BGM = Sound.new('sound/game3.wav')
    end

    BACKGROUND = Image.load('images/background_game.png')
    DOHYO = Image.load('images/sumo_dohyou.png')
    P1_IMAGE = Image.load('images/osumou.png')
    P2_IMAGE = Image.load('images/osumou2.png')
    COUNTDOWN3 = Image.load('images/3_03.gif')
    COUNTDOWN2 = Image.load('images/2_03.gif')
    COUNTDOWN1 = Image.load('images/1_03.gif')
    FIGHT = Image.load('images/_FIGHT!_03.gif')


    def initialize
      @players = []
      @players << Player.new(150, 300, P1_IMAGE, 1, Controller1.new, 'sumo1')
      @players << Player.new(390, 300, P2_IMAGE, -1, Controller2.new, 'sumo2')

      @player_hash = {}
      @players.each do |player|
        @player_hash[player.name] = player
      end
    end

    time_ms = 0

    def play
      Window.draw(0, 0, BACKGROUND)
      Window.draw(0, 0, DOHYO)
      if time_ms < 4
        case time_ms
        when 0 then
          Window.draw(250,150,COUNTDOWN3)
        when 1 then
          Window.draw(250,150,COUNTDOWN2)
        when 2 then
          Window.draw(250,150,COUNTDOWN1)
        when 3 then
          Window.draw(250,150,FIGHT)
        end
        Window.draw(150, 300, P1_IMAGE)
        Window.draw(390, 300, P2_IMAGE)
        sleep(1000)
        time_ms += 1
      else
        Sprite.update(@players)
        Sprite.clean(@players)
      end
    end

    def change_bgm
      Scene[:title].class::BGM.stop
      BGM.play
    end
  end
end
