module CrystalInsideFort
  module HELPER
    class FortLogger
      @console = Logger.new(STDOUT)

      def initialize
        @console.level = Logger::DEBUG
      end

      def info(*args)
        @console.info(join_args(args))
      end

      def error(*args)
        @console.error(join_args(args))
      end

      def console(*args)
        debug(args)
      end

      def debug(*args)
        @console.debug(join_args(args))
      end

      private def join_args(args)
        message = ""
        args.each do |value|
          message += " #{value}"
        end
        message
      end
    end
  end
end
