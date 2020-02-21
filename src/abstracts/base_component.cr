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
        # return @context.as(RequestHandler).result_channel.send(
        #   HttpResult.new(view_data, MIME_TYPE["html"])
        # )
      end

      def json_result(value)
        # result = HttpResult.new(value.to_json, MIME_TYPE["json"])
        # @context.as(RequestHandler).result_channel.send(result)
        return HttpResult.new(value.to_json, MIME_TYPE["json"])
      end

      def nil_result
        # @context.as(RequestHandler).result_channel.send(nil)
        return nil
      end

      def text_result(value : String)
        # result = HttpResult.new(value, MIME_TYPE["text"])
        # @context.as(RequestHandler).result_channel.send(result)
        return HttpResult.new(value, MIME_TYPE["text"])
      end
    end
  end
end
