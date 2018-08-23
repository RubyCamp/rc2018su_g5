module Result
  class Director
    attr_accessor :winner

    BACKGROUND = Image.load('images/result/background.png')

    case rand(3)
    when 0
      BGM = Sound.new('bgm/result1.wav')
    when 1
      BGM = Sound.new('bgm/result2.wav')
    when 2
      BGM = Sound.new('bgm/result3.wav')
    end

    def initialize
      @player_images = [Image.load('images/result/winner_l.png'), Image.load('images/result/winner_r.png')]
      @winner = 0
    end

    def play
      Window.draw(0, 0, BACKGROUND)

      # result = Scene[:game].players.map{|player| [player.name, ] }.to_h
      # winner = result.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.first
      img = @player_images[Scene[:game].get_winner]
      Window.draw(0, 0, img)

      if Input.key_push?(K_SPACE)
        Scene[:title].change_bgm
        Scene.remove(:game)
        Scene.add(:game, Game::Director.new)
        Scene.current = :title
      end
    end

    def change_bgm
      Scene[:game].class::BGM.stop
      BGM.play
    end
  end
end
