module Whack
  class Objects::Text < Whack::Objects::Base
    attr_accessor :text, :color

    # TODO: more style options, z, etc.
    def initialize(x, y, text, size = 20, color = Gosu::Color::WHITE)
      super(x, y)
      @text = text
      @color = color
      @size = size
    end

    def draw
      font.draw_text(@text, @x, @y, 10, 1.0, 1.0)
    end

    private

    def font
      @font ||= Gosu::Font.new(@size, {})
    end
  end
end
