module CrystalInsideFort
  module HELPER
    class Async(T)
      @channel = Channel(T).new

      def initialize(@task : Proc(T))
        spawn do
          result = @task.call
          @channel.send(result)
        end
      end

      def await
        @channel.receive
      end

      def yield
        Fiber.yield
      end

      def yield_await
        self.yield
        self.await
      end

      # static class AwaitAll(T)
      #   @results = [] of T

      #   def initialize(async_task_list : Array(Async))
      #     async_task_list.each do |task|
      #       task.await
      #     end
      #   end

      #   def results
      #     return @results
      #   end
      # end

      def Async.await_many(task_list : Array(Async))
        return Async(Array(T)).new (->{
          results = [] of T
          task_list.each do |task|
            results.push(task.await)
          end
          return results
        })
      end
    end
  end
end
