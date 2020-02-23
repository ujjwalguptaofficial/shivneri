require "json"

module CrystalInsideFort
  module ABSTRACT
    class BaseComponent
      @context : RequestHandler | Nil = nil

      def set_context(context)
        @context = context
      end

      def request
        return @context.as(RequestHandler).request
      end

      def response
        return @context.as(RequestHandler).response
      end

      def query
        return @context.as(RequestHandler).query
      end

      def cookie
        return @context.as(RequestHandler).cookie_manager
      end

      def session
        return @context.as(RequestHandler).session_provider.as(SessionProvider)
      end

      def logger
        return @context.as(RequestHandler).logger
      end

      def file
        return @context.as(RequestHandler).file
      end

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

      def nil_result
        return nil
      end

      def text_result(value : String, status_code = 200)
        return HttpResult.new(value, MIME_TYPE["text"], status_code)
      end

      def redirect_result(url : String)
        return HttpResult.new(url, MIME_TYPE["text"], true)
      end

      def html_result(value : String, status_code = 200)
        return HttpResult.new(value, MIME_TYPE["html"], status_code)
      end
    end
  end
end
