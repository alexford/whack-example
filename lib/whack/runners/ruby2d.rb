# Proof of concept runner/renderer
# Simple, single threaded: game is called once per update (60hz)

require 'ruby2d'

module Whack
  class Runners::Ruby2d

    def initialize(game, base_env = {})
      @base_env = base_env
      @game = game
      @start = 0
      @clock = 0
      @frame = 0
      @game_objects = []
      @game_state = {}
      @down_keys = []

      @last_game_times = []
      @last_update_times = []
    end

    def run
      initialize_window!
      register_update!
      @start = mono_time
      @window.show
    end

    def stop
      # TODO: stop loop somehow (some kind of poison?)
    end

    private

    def env
      @base_env.merge({
        clock: @clock,
        input: {
          keys: @down_keys
        }
      })
    end

    def window
      @window ||= Ruby2D::Window.current
    end

    def initialize_window!
      window.set title: 'Whack POC' # TODO from config
      window.set background: 'blue'

      # All this stuff comes from ruby2d
      # TODO: isolate, using this DSL directly seems weird
      window.on :key_down do |event|
        @down_keys << event.key
        @down_keys.uniq!
      end

      window.on :key_up do |event|
        @down_keys.uniq!
        @down_keys = @down_keys - [event.key]
      end
    end

    def dummy_objects
      @dummy_objects ||= Array.new(1000) do
        {
          x: rand(640), y: rand(240) + 120,
          width: 10, height: 10,
          color: 'white'
        }
      end
    end

    def register_update!
      # TODO: move somewhere else
      window.update do
        loop_start = mono_time
        @clock = loop_start - @start

        # Call the game
        @game_state, @game_objects = @game.call(env)
        record_game_time(mono_time - loop_start)

        window.clear

        @game_objects.each do |args|
          # assume all objects are arguments for ruby2d Rectangles, API TBD!
          Rectangle.new(**args)
        end
        render_debug_text


        record_update_time(mono_time - loop_start)

        @frame += 1
      end
    end

    def game_ractor

    end

    def mono_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def minimum_update_time
      1.0 / MAX_UPS
    end

    def earliest_update_time_from(now)
      now + minimum_update_time
    end

    def record_game_time(time)
      @last_game_times << time
      @last_game_times = @last_game_times.last(100)
    end

    # Moving average time it takes to hear back from the game Ractor
    def average_game_time
      # don't guess until we have enough data points
      return 0.0 if @last_game_times.size < 50

      @last_game_times.sum(0.0) / @last_game_times.size
    end

    def record_update_time(time)
      @last_update_times << time
      @last_update_times = @last_update_times.last(100)
    end

    # Average time it takes for the whole update loop, including UPS throttle wait
    def average_update_time
      # don't guess until we have enough data points
      return 0.0001 if @last_update_times.size < 50

      @last_update_times.sum(0.0) / @last_update_times.size
    end

    def wait_until_next_update(update_start)
      while mono_time < earliest_update_time_from(update_start)
      end
    end

    def render_debug_text
      # TODO: move debug text somewhere else, configurable
      start_x = 10
      start_y = window.get(:height) - 30

      Text.new(
        "FPS #{window.get(:fps).floor(0)}/#{window.get(:fps_cap)}",
        x: start_x, y: start_y,
        style: 'bold',
        size: 18,
        color: 'white',
        z: 1000
      )

      game_ms = (average_game_time * 1000).round
      update_ms = (average_update_time * 1000).round

      Text.new(
        "T/G #{update_ms}/#{game_ms}ms",
        x: start_x + 300, y: start_y,
        style: 'bold',
        size: 18,
        color: 'white',
        z: 1000
      )
    end
  end
end
