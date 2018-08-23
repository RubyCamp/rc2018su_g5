module Title
  class Director
    BACKGROUND = Image.load('images/title/background.png')

    case rand(3)
    when 0
      BGM = Sound.new('bgm/title1.wav')
    when 1
      BGM = Sound.new('bgm/title2.wav')
    when 2
      BGM = Sound.new('bgm/title3.wav')
    end

    def play
      Window.draw(0, 0, BACKGROUND)
      Window.draw_font(250, 480, 'PUSH SPACE', Font.new(48), color: C_BLACK)
      if Input.key_push?(K_SPACE)
        Scene[:game].change_bgm
        Scene.current = :game
      end
    end

    def change_bgm
      Scene[:result].class::BGM.stop
      BGM.play
    end
  end
end
