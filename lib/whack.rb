# TODO: zeitwerk or something
class Whack
  class Runners
  end
end

class Whack
  class Objects
  end
end

require_relative 'whack/runners/gosu.rb'
require_relative 'whack/objects/rectangle.rb'
require_relative 'whack/objects/rectangle_vectors.rb'

class Whack
  def initialize(game_klass, runner_klass = Whack::Runners::Gosu)
    @game_klass = game_klass
    @runner_klass = runner_klass
  end

  def run
    runner.run
  end

  def self.env
    'development'
  end

  private

  def base_env
    {
      environment: Whack.env,
      window: {
        width: 1920,
        height: 1080
      }
    }
  end

  def runner
    @runner ||= @runner_klass.new(@game_klass, base_env)
  end
end

def run(game)
  # todo config, etc.
  whack = Whack.new(game)
  whack.run
end
