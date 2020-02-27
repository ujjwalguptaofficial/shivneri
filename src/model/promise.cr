module Shivneri
  module MODEL
    class Async(T)
      @channel = Channel.new(T)

      def initialize(@task : Proc(&block, T))
        spawn do
          @task.call(complete)
        end
      end

      def complete
      end
    end
  end
end
