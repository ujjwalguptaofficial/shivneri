require "../fort_global"
require "../constants"
require "../hashes/index"
require "http"

module CrystalInsideFort
  module Handlers
    include HASHES

    class RequestHandlerHelper
      getter wall_instances
      @wall_instances = [] of Wall

      protected def run_wall_out_going
        @wall_instances.reverse.each do |wall_instance|
          wall_instance.on_outgoing
        end
      end

      protected def onErrorOccured(error : Exception)
        errMessage : String = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_server_error(error)
        rescue ex
          errMessage = "#{ex.message}"
        end
        @response.content_type = MIME_TYPE["html"]
        @response.status = HTTP::Status::INTERNAL_SERVER_ERROR
        @response.print(errMessage)
      end

      protected def on_bad_request(error)
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_bad_request(error)
        rescue ex
          return self.onErrorOccured(ex)
        end
        @response.content_type = MIME_TYPE["html"]
        @response.status = HTTP::Status::BAD_REQUEST
        @response.print(errMessage)
      end

      protected def on_request_options(allowedMethods : Array(String))
        begin
          self.run_wall_out_going
        rescue ex
          return self.onErrorOccured(ex)
        end
        @response.headers.add("Allow", allowedMethods.join(","))
        @response.content_type = MIME_TYPE["html"]
        @response.status = HTTP::Status::OK
        @response.print("")
      end

      protected def on_method_not_allowed(allowedMethods : Array(String))
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_method_not_allowed
        rescue ex
          return self.onErrorOccured(ex)
        end
        @response.headers.add("Allow", allowedMethods.join(","))
        @response.content_type = MIME_TYPE["html"]
        @response.status = HTTP::Status::METHOD_NOT_ALLOWED
        @response.print(errMessage)
      end
    end
  end
end
