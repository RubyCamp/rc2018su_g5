module Title
  class Director
    BACKGROUND = Image.load('images/background_title.png')

    case rand(3)
    when 0 then
      BGM = Sound.new('sound/title1.wav')
    when 1 then
      BGM = Sound.new('sound/title2.wav')
    when 2 then
      BGM = Sound.new('sound/title3.wav')
    end

    def play
      Window.draw(0, 0, BACKGROUND)
      if Input.key_push?(K_SPACE)
        Scene[:game].change_bgm
        Scene.current = :game
      end
    end

  end
end
