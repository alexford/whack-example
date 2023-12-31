module Whack
  module Utils
    def timed_block
      start_time = mono_time
      result = yield
      [result, mono_time - start_time]
    end

    def mono_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def seconds_to_ms(seconds)
      (seconds * 1000).round(2)
    end
  end
end
