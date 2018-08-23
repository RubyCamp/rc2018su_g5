require 'dxruby'
require_relative 'scene'
require_relative 'scenes/game/director'
require_relative 'scenes/result/director'
require_relative 'scenes/title/director'

Window.caption = '愛と怒りとしじみ汁'
Window.bgcolor = C_WHITE
Window.width = 800
Window.height = 600

Scene.add(:title, Title::Director.new)
Scene.add(:game, Game::Director.new)
Scene.add(:result, Result::Director.new)
Scene.current = :title

Scene[:title].class::BGM.loop_count = -1
start = 0

Window.loop do
  if start == 0
    Scene[:title].class::BGM.play
    start = 1
  end
  break if Input.key_push?(K_ESCAPE)
  Scene.play
end
