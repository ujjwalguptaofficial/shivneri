module CrystalInsideFort
  module Abstracts
    abstract class Shield
      property context
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil

      @context : RequestHandler | Nil = nil

      def query
        return @context.as(RequestHandler).query
      end

      abstract def protect(*args)
    end
  end
end
