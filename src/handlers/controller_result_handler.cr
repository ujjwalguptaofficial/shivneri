require "../fort_global"
require "./request_handler_helper"

module CrystalInsideFort
  module Handlers
    class ControllerResultHandler < RequestHandlerHelper
      @controller_result : HttpResult = HttpResult.new("", "")

      private def on_termination_from_Wall(result : HttpResult | Nil)
        handle_final_result(result)
      end

      private def endResponse_(negotiateMimeType : String)
        # let data
        begin
          # data = getResultBasedOnMiMe(negotiateMimeType,
          #     this.controllerResult_.responseData
          #     , (type: MIME_TYPE) => {
          #         negotiateMimeType = type;
          #     }
          # );
        rescue ex
          self.onErrorOccured(ex)
          return
        end
        puts "result is #{@controller_result.to_json}"
        # @response.headers[CONSTANTS.content_type] = negotiateMimeType
        @response.content_type = negotiateMimeType
        @response.status_code = @controller_result.status_code
        @response.print(@controller_result.response_data)
       
      end

      protected def on_result_from_controller(result : HttpResult)
        begin
          # await this.runWallOutgoing
        rescue ex
          self.onErrorOccured(ex)
          return
        end
        self.handle_final_result(result)
      end

      private def handle_final_result(result : HttpResult)
        puts result
        # result = result || textResult("")
        @controller_result = result
        # ((this.cookieManager as any).responseCookie_ as string[]).forEach(value => {
        #     this.response.setHeader(__SetCookie, value);
        # });

        # if ((result as HttpResult).shouldRedirect === true) {
        #     this.handleRedirectResult_();
        # }
        # else {
        #     if ((result as HttpFormatResult).responseFormat == null) {
        #         if ((result as HttpResult).file == null) {
        contentType = result.as(HttpResult).content_type || MIME_TYPE["text"]
        #             const negotiateMimeType = this.getContentTypeFromNegotiation(contentType) as MIME_TYPE;
        #             if (negotiateMimeType != null) {
        # this.endResponse_(negotiateMimeType);
        self.endResponse_(contentType)
        #             }
        #             else {
        #                 this.onNotAcceptableRequest();
        #             }
        #         }
        #         else {
        #             this.handleFileResult_();
        #         }
        #     }
        #     else {
        #         this.handleFormatResult_();
        #     }
        # }
      end
    end
  end
end
