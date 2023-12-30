# TODO: zeitwerk or something
class Bout
  class Runners
  end
end

class Bout
  class Objects
  end
end

require_relative 'bout/runners/gosu.rb'
require_relative 'bout/objects/rectangle.rb'
require_relative 'bout/objects/rectangle_vectors.rb'

class Bout
  def initialize(game_klass, runner_klass = Bout::Runners::Gosu)
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
      environment: Bout.env,
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
  bout = Bout.new(game)
  bout.run
end
