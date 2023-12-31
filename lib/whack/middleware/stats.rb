# frozen_string_literal: true

# Middleware that draws stats
require_relative '../objects/text'

module Whack
  class Stats
    include Whack::Utils

    STAT_PAIRS = [
      ["FPS", -> (_, _, _) { Gosu.fps }], # TODO: abstract Gosu call?
      ["Objects", -> (_, _, layers) { (layers.sum { |l| l.count }).to_s + " (#{layers.count} layers)" }],
      ["Game Time", -> (_, _, _) { seconds_to_ms(average_game_time).to_s + "ms" }],
    ].freeze

    def initialize(app)
      @app = app
      @text_objects = {}
      build_text_objects
    end

    def call(env)
      result, elapsed = timed_block do
        @app.call(env)
      end
      record_game_time(elapsed)

      state, layers = result

      # TODO: maybe find a way for Gosu to understand "debug text in state goes in top left"
      # rather than adding a "real" game layer?
      layers << updated_text_objects(env, state, layers)

      [state, layers]
    end

    private

    def updated_text_objects(env, state, layers)
      STAT_PAIRS.map do |pair|
        @text_objects[pair[0]].tap do |object|
          object.text = "#{pair[0]}: #{instance_exec(env, state, layers, &pair[1])}"
        end
      end
    end

    def build_text_objects
      STAT_PAIRS.each_with_index do |pair, i|
        @text_objects[pair[0]] = Whack::Objects::Text.new(30, 30 + i * 25, "#{pair[0]}: ")
      end
    end

    def record_game_time(time)
      @last_game_times ||= []

      @last_game_times << time
      @last_game_times = @last_game_times.last(100)
    end

    # Moving average time it takes to hear back from the game
    def average_game_time
      # don't guess until we have enough data points
      return 0.0 if @last_game_times.size < 50

      @last_game_times.sum(0.0) / @last_game_times.size
    end
  end
end
