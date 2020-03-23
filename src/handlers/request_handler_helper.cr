require "../fort_global"
require "../constants"
require "../hashes/index"
require "http"
require "../exceptions/index"

module Shivneri
  module Handlers
    include HASHES
    include EXCEPTION

    class RequestHandlerHelper
      getter wall_instances, cookie_manager
      @wall_instances = [] of Wall
      @cookie_manager : CookieManager | Nil = nil

      protected def cookie_manager=(@cookie_manager)
      end

      private def get_available_types(type : String)
        case type
        when MIME_TYPE["json"]
        when MIME_TYPE["xml"]
          return [MIME_TYPE["json"], MIME_TYPE["xml"]]
        when MIME_TYPE["html"]
        when MIME_TYPE["css"]
        when MIME_TYPE["csv"]
        when MIME_TYPE["js"]
        when MIME_TYPE["rtf"]
        when MIME_TYPE["text"]
          return [
            MIME_TYPE["text"], MIME_TYPE["html"], MIME_TYPE["js"],
            MIME_TYPE["css"], MIME_TYPE["rtf"], MIME_TYPE["csv"],
          ]
        end
        return [type]
      end

      protected def get_content_type_from_negotiation(type : String)
        negotiator = Negotiator.new
        available_types = self.get_available_types(type)
        if (request.headers.has_key?("accept"))
          return negotiator.media_type(request.headers["accept"], available_types)
        elsif (request.headers.has_key?("Accept"))
          return negotiator.media_type(request.headers["Accept"], available_types)
        end
        return negotiator.media_type(available_types)
      end

      protected def get_content_type_from_negotiation(available_types : Array(String))
        negotiator = Negotiator.new
        if (request.headers.has_key?("accept"))
          return negotiator.media_type(request.headers["accept"], available_types)
        elsif (request.headers.has_key?("Accept"))
          return negotiator.media_type(request.headers["Accept"], available_types)
        end
        return negotiator.media_type(available_types)
      end

      protected def run_wall_out_going
        @wall_instances.reverse.each do |wall_instance|
          wall_instance.outgoing
        end
      end

      protected def on_error_occured(error : Exception)
        errMessage : String = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_server_error(error)
        rescue ex
          errMessage = "#{ex.message}"
        end
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::INTERNAL_SERVER_ERROR
        response.print(errMessage)
      end

      protected def on_bad_request(error)
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_bad_request(error)
        rescue ex
          return self.on_error_occured(ex)
        end
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::BAD_REQUEST
        response.print(errMessage)
      end

      protected def on_request_options(allowedMethods : Array(String))
        begin
          self.run_wall_out_going
        rescue ex
          return self.on_error_occured(ex)
        end
        response.headers.add("Allow", allowedMethods.join(","))
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::OK
        response.print("")
      end

      protected def on_not_acceptable_request
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_not_acceptable_request
        rescue ex
          return self.on_error_occured(ex)
        end
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::NOT_ACCEPTABLE
        response.print(errMessage)
      end

      protected def on_method_not_allowed(allowedMethods : Array(String))
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_method_not_allowed
        rescue ex
          return self.on_error_occured(ex)
        end
        response.headers.add("Allow", allowedMethods.join(","))
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::METHOD_NOT_ALLOWED
        response.print(errMessage)
      end

      protected def on_not_found
        errMessage = ""
        begin
          self.run_wall_out_going
          errMessage = FortGlobal.error_handler.new.on_not_found(request.path)
        rescue ex
          return self.on_error_occured(ex)
        end
        response.content_type = MIME_TYPE["html"]
        response.status = HTTP::Status::NOT_FOUND
        response.print(errMessage)
      end
    end
  end
end
