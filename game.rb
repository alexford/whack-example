require_relative './game/star'
require 'pry'

class Game
  def self.call(env)
    @instance ||= self.new(env)
    @instance.call(env)
  end

  def initialize(env)
    @counter = 0
    @last_updated = 0
    @objects = Array.new(2_000).map! { new_star(env) }
  end

  def new_star(env)
    size = Whack::Backend.random(0,5).floor + 1
    x = Whack::Backend.random(0,env[:window][:width]).floor
    y = Whack::Backend.random(0,env[:window][:height]).floor

    Star.new(x, y, size)
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
