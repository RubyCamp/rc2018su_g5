require_relative 'player'
require_relative 'gauge'
require_relative 'controller'
require_relative 'controller1'
require_relative 'controller2'

module Game
  class Director
    attr_accessor :player1, :player2

    def initialize
      @players = []
      @players << Player.new(@players, 50, 240, 10, 30, 90, 100, Controller1.new)
      @players << Player.new(@players, Window.width - 318, 240, 10, 30, 90, 100, Controller2.new)
      @gauges = []
      @gauges << Gauge.new(50, 50, 257, 24, @players[0])
      @gauges << Gauge.new(Window.width - 318, 50, 257, 24, @players[1], true)
    end

    def play
      @players.each do |player|
        player.update
      end

      @gauges.each do |gauge|
        gauge.update
      end
    end
  end
end
