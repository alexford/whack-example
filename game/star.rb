class Game
  class Star
    MIN_LIFETIME = 5.0
    MAX_LIFETIME = 30.0

    attr_reader :remaining_lifetime

    def initialize(x, y, size)
      @x = x
      @y = y
      @size = size
      @remaining_lifetime = rand(MIN_LIFETIME..MAX_LIFETIME)
    end

    def move(dt, max_x, max_y)
      @remaining_lifetime = [remaining_lifetime - dt, 0].max

      if (remaining_lifetime < 1.0)
        @size = [@size - remaining_lifetime, 0].max
      end

      # Just some swirly movement
      @x += 1
      @y += 1

      @y += Math.sin(@x / 200.0 + (dt / 30.0)) * @size
      @x += Math.cos(@y / 100.0 + (dt / 30.0)) * @size

      if @x >= max_x
        @x = 0
      end

      if @y >= max_y
        @y = 0
      end

      if @y < 0
        @y = max_y
      end

      if @x < 0
        @x = max_x
      end
    end

    def draw
      rectangle.x = @x
      rectangle.y = @y
      rectangle.w = rectangle.h = @size
      rectangle.draw
    end

    private

    def rectangle
      @rectangle ||= Whack::Objects::RectangleVectors.new(@x, @y, @size, @size)
    end
  end
end
