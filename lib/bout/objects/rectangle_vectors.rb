require_relative './rectangle.rb'

class Bout
  class Objects::RectangleVectors < Bout::Objects::Rectangle

    def initialize(*args)
      super(*args)
      @last_x = @x
      @last_y = @y
    end

    def draw
      if (@w > 2)
        Gosu::draw_rect(@last_x, @last_y, @w, @h, Gosu::Color::WHITE)
        @last_x = @x
        @last_y = @y
      end
      super
    end
  end
end
