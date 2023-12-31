require_relative '../runner_helpers.rb'

module Whack
  class Runners::Base
    include RunnerHelpers

    attr_accessor :clock, :frame
    attr_reader :game, :start, :layers

    def initialize(game, base_env = {})
      @base_env = base_env
      @game = game
      @start = 0
      @clock = 0
      @frame = 0
      @layers = []
      @state = {}
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
      @state, @layers = @game.call(env)
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
