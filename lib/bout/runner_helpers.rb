module Bout::RunnerHelpers
  def mono_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
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

  def record_update_time(time)
    @last_update_times ||= []

    @last_update_times << time
    @last_update_times = @last_update_times.last(100)
  end

  # Average time it takes for the whole update loop, including UPS throttle wait
  def average_update_time
    # don't guess until we have enough data points
    return 0.0001 unless (@last_update_times || []).size > 50

    @last_update_times.sum(0.0) / @last_update_times.size
  end

  def fps_debug_text
    "FPS #{current_fps}"
  end

  def timing_debug_text
    game_ms = (average_game_time * 1000).round
    draw_ms = (average_update_time * 1000).round
    "D/G #{draw_ms}/#{game_ms}ms"
  end
end
