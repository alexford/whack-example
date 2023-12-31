require 'gosu'

module Whack
  class Objects::Base
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def draw
      # Should be overriden
      Gosu::draw_rect(@x, @y, @x, @y, Gosu::Color::WHITE)
    end
  end
end
