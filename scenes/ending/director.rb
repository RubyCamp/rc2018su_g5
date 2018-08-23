module Ending
  class Director
    BACKGROUND = Image.load('images/ending.png')

    case rand(3)
    when 0 then
      BGM = Sound.new('sound/result1.wav')
    when 1 then
      BGM = Sound.new('sound/result2.wav')
    when 2 then
      BGM = Sound.new('sound/result3.wav')
    end

    def initialize
      @player_images = {
        'sumo1' => Image.load('images/hidarigawa.png'),
        'sumo2' => Image.load('images/migigawa.png')
      }
    end

    def play
      Window.draw(0, 0, BACKGROUND)

      result = Scene[:game].players.map{|player| [player.name,____________] }.to_h
      winner = result.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.first
      img = @player_images[winner.first]
      Window.draw(0, 0, img)
    end

    def change_bgm
      Scene[:game].class::BGM.stop
      BGM.play
    end

  end
end
