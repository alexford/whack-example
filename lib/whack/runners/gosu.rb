# Proof of concept runner/renderer based on Gosu
# Simple, single threaded: game is called once per update (60hz)

require 'gosu'
require_relative './base.rb'

module Whack
  class Runners::Gosu < Whack::Runners::Base
    def run
      super
      window.show
    end

    def stop
      super
      # TODO: stop loop somehow (some kind of poison?)
    end

    def down_keys
      @window&.down_keys || []
    end

    private

    def window
      @window ||= Window.new(self)
    end

    class Window < Gosu::Window
      private attr_reader :runner
      attr_reader :down_keys

      def initialize(runner)
        @runner = runner
        @down_keys = []
        super runner.env[:window][:width], runner.env[:window][:height]
        self.caption = "Whack Gosu" # TODO: config game name
      end

      def update
        runner.call_game!
      end

      def draw
        update_start = runner.mono_time

        runner.layers&.each do |layer|
          layer&.each do |object|
            object.draw
          rescue => e
            puts e
          end
          Gosu.flush
        end

        runner.record_update_time(runner.mono_time - update_start)
        #render_debug_text

        runner.frame += 1
      end

      def button_down(id)
        @down_keys << id
        @down_keys.uniq!
      end

      def button_up(id)
        @down_keys.uniq!
        @down_keys = @down_keys - [id]
      end

      private

      def render_debug_text
        # TODO: move debug text somewhere else, configurable
        start_x = 10
        start_y = self.height - 30

        @font ||= Gosu::Font.new(20)
        @font.draw_text(runner.fps_debug_text, start_x, start_y, 10, 1.0, 1.0, Gosu::Color::WHITE)
        @font.draw_text(runner.timing_debug_text, start_x+200, start_y, 10, 1.0, 1.0, Gosu::Color::WHITE)
      end
    end

    def current_fps
      Gosu.fps
    end
  end
end
