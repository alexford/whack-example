require_relative '../runner_helpers.rb'

class Bout
  class Runners::Base
    include RunnerHelpers

    attr_accessor :clock, :frame
    attr_reader :game, :start, :game_objects

    def initialize(game_klass, base_env = {})
      @base_env = base_env
      @game = game_klass.new(env)
      @start = 0
      @clock = 0
      @frame = 0
      @game_objects = []
      @game_state = {}
      @down_keys = []
    end

    def run
      @start = mono_time
      # override in base class with super
    end

    def stop
      # TODO: some kind of poison?
    end

    def current_fps
      0 # override with real value in subclass
    end

    def down_keys
      [] # override in sub class
    end

    def call_game!
      game_call_start = mono_time
      @clock = game_call_start - @start

      @game_state, @game_objects = @game.call(env)

      record_game_time(mono_time - game_call_start)
    end

    def env
      @base_env.merge({
        clock: @clock,
        input: {
          keys: down_keys
        }
      })
    end
  end
end
