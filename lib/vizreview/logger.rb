module VizReview
  class Logger
    class << self
      LOG_LEVELS = [:debug, :info, :warn, :fatal]

      @level = :fatal

      def level=(level)
        raise ArgumentError.new('Invalid log level') unless level.to_sym.in?(LOG_LEVELS)
        @level = level.to_sym
      end

      def log(msg)
        puts "#{prefix}#{msg}".strip
      end

      def debug(msg)
        return unless log?(:debug)
        log("[DEBUG] #{msg}")
      end

      def prefix=(prefix)
        @prefix = prefix
      end

      def prefix
        @prefix || ''
      end

      private

      def log?(level)
        curr_index = LOG_LEVELS.index(@level)
        level_index = LOG_LEVELS.index(level)
        level_index >= curr_index
      end
    end
  end
end
