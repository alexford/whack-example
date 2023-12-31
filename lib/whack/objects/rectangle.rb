require_relative './base.rb'

class Whack
  class Objects::Rectangle < Whack::Objects::Base
    attr_accessor :x, :y, :w, :h

    def initialize(x, y, w, h, color = Gosu::Color::WHITE)
      super(x, y)
      @w = w
      @h = h
      @color = color
    end

    def draw
      Gosu::draw_rect(@x, @y, @w, @h, Gosu::Color::WHITE)
    end
  end
end
