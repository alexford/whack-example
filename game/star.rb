class Game
  class Star
    MIN_LIFETIME = 5.0
    MAX_LIFETIME = 30.0

    attr_reader :remaining_lifetime

    def initialize(x, y, size)
      @x = @original_x = x
      @y = @original_y = y
      @size = @original_size = size
      @remaining_lifetime = @original_lifetime = rand(MIN_LIFETIME..MAX_LIFETIME)
    end

    def move(dt, max_x, max_y)
      @remaining_lifetime = [remaining_lifetime - dt, 0].max
      elapsed_lifetime = @original_lifetime - @remaining_lifetime

      if (remaining_lifetime < 1.0)
        @size = [@original_size * remaining_lifetime, 0].max
      end

      # Just some swirly movement
      @y = @original_y + Math.sin(@x / 200.0 + elapsed_lifetime * 2) * 10 * @size
      @x = @original_x + Math.cos(@y / 100.0 + elapsed_lifetime * 2) * 10 * @size

      # Wrap around at the edges
      # @x = @original_x = 0 if @x >= max_x
      # @y = @original_y = 0 if @y >= max_y
      # @x = @original_x = max_x if @x < 0
      # @y = @original_y = max_y if @y < 0
    end

    def draw
      rectangle.position = @x, @y
      rectangle.size = @size
      rectangle.draw
    end

    private

    def rectangle
      @rectangle ||= Whack::Objects::Rectangle.new(@x, @y, @size, @size)
    end
  end
end
