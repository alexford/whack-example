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

      sprite.x = @x
      sprite.y = @y
      sprite.w = @sprite.h = @size
    end

    def draw
      sprite.draw
    end

    private

    def sprite
      @sprite ||= Whack::Objects::Rectangle.new(@x, @y, @size, @size)
    end
  end

  def self.call(env)
    @instance ||= self.new(env)
    @instance.call(env)
  end

  def initialize(env)
    @counter = 0
    @last_updated = 0
    @objects = Array.new(1000).map! { new_star(env) }
  end

  def new_star(env)
    size = rand(5) + 1
    Star.new(rand(env[:window][:width]), rand(env[:window][:height]), size)
  end

  def name
    "Whack POC"
  end

  def call(env)
    @counter += 1
    @elapsed = env[:clock] - @last_updated
    @last_updated = env[:clock]

    if env[:input][:keys].any?
      if @elapsed > 0.0
        @objects.prepend new_star(env)
      end
    end

    @objects.map! do |star|
      (star.remaining_lifetime > 0 ? star : new_star(env)).tap do |star_to_move|
        star_to_move.move(@elapsed, env[:window][:width], env[:window][:height])
      end
    end

    # [state, [layers]]
    [{ counter: @counter }, [@objects]]
  end
end
