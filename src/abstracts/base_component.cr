require "json"
require "./base_web_socket_controller"

module Shivneri
  module ABSTRACT
    class BaseComponent < BaseWebSocketController
      # @context : RequestHandler | Nil = nil

      # def set_context(context)
      #   @context = context
      # end

      # def request
      #   return @context.as(RequestHandler).request
      # end

      def response
        return @context.as(RequestHandler).response
      end

      # def query
      #   return @context.as(RequestHandler).query
      # end

      # def component_data
      #   return @context.as(RequestHandler).component_data
      # end

      # def [](key : String)
      #   return component_data[key]
      # end

      # def []?(key : String)
      #   return component_data[key]?
      # end

      # def []=(key : String, value : JSON::Any::Type)
      #   component_data[key] = JSON::Any.new(value)
      # end

      # def []=(key : String, value : JSON::Any)
      #   component_data[key] = value
      # end

      # def []=(key : String, value : Int32)
      #   self[key] = value.to_i64
      # end

      def worker_name
        return @context.as(RequestHandler).worker_name
      end

      def cookie
        return @context.as(RequestHandler).cookie_manager.as(CookieManager)
      end

      def session
        return @context.as(RequestHandler).session_provider.as(SessionProvider)
      end

      # def logger
      #   return @context.as(RequestHandler).logger
      # end

      def render_view(view_name : String, model)
        return FortGlobal.view_engine.render(ViewEngineData.new(view_name, model))
      end

      def view_result(view_name : String)
        model = {} of String => String
        return view_result(view_name, model)
      end

      def view_result(view_name : String, model : _)
        view_data = render_view(view_name, model).await
        return HttpResult.new(view_data, MIME_TYPE["html"])
      end

      def json_result(value, status_code = 200)
        return HttpResult.new(value.to_json, MIME_TYPE["json"], status_code)
      end

      def json_result(value : String, status_code = 200)
        return HttpResult.new(value, MIME_TYPE["json"], status_code)
      end

      def json_result(value : ALIAS::StringConvertableType, status_code = 200)
        return HttpResult.new(value.to_s, MIME_TYPE["json"], status_code)
      end

      def nil_result
        return nil
      end

      def text_result(value : String, status_code = 200)
        return HttpResult.new(value, MIME_TYPE["text"], status_code)
      end

      def text_result(value : ALIAS::StringConvertableType, status_code = 200)
        return HttpResult.new(value.to_s, MIME_TYPE["text"], status_code)
      end

      def redirect_result(url : String)
        return HttpResult.new(url, MIME_TYPE["text"], true)
      end

      def html_result(value : String, status_code = 200)
        return HttpResult.new(value, MIME_TYPE["html"], status_code)
      end

      def download_result(path : String)
        http_result = HttpResult.new("", "")
        http_result.file = FileResultInfo.new(path, true, File.basename(path))
        return http_result
      end

      def download_result(path : String, file_name_with_extension : String)
        http_result = HttpResult.new("", "")
        http_result.file = FileResultInfo.new(path, true, file_name_with_extension)
        return http_result
      end

      def file_result(path : String)
        http_result = HttpResult.new("", "")
        http_result.file = FileResultInfo.new(path, File.basename(path))
        return http_result
      end

      def file_result(path : String, file_name_with_extension : String)
        http_result = HttpResult.new("", "")
        http_result.file = FileResultInfo.new(path, file_name)
        return http_result
      end

      def format_result(value : Hash(String, String), status_code = 200)
        HttpResult.new(value, status_code)
      end
    end
  end
end
