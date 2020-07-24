require "log"

module Shivneri
  module HELPER
    class Logger
      def info(*args)
        Log.info { join_args(args) }
      end

      def error(*args)
        Log.error { join_args(args) }
      end

      def console(*args)
        debug(args)
      end

      def debug(*args)
        Log.debug { join_args(args) }
      end

      protected def join_args(args)
        message = ""
        args.each do |value|
          message += " #{value}"
        end
        message
      end
    end
  end
end
