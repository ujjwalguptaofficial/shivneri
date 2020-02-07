require "../fort_global"
require "./request_handler_helper"

module CrystalInsideFort
  module Handlers
    class ControllerResultHandler < RequestHandlerHelper
      private def onTerminationFromWall(result : HttpResult | HttpFormatResult)
        # @handleFinalResult_(result);
      end

      private def handleFinalResult_(result : HttpResult | HttpFormatResult)
        # result = result || textResult("");
        # this.controllerResult_ = result as HttpResult;

        # ((this.cookieManager as any).responseCookie_ as string[]).forEach(value => {
        #     this.response.setHeader(__SetCookie, value);
        # });

        # if ((result as HttpResult).shouldRedirect === true) {
        #     this.handleRedirectResult_();
        # }
        # else {
        #     if ((result as HttpFormatResult).responseFormat == null) {
        #         if ((result as HttpResult).file == null) {
        #             const contentType = (result as HttpResult).contentType || MIME_TYPE.Text;
        #             const negotiateMimeType = this.getContentTypeFromNegotiation(contentType) as MIME_TYPE;
        #             if (negotiateMimeType != null) {
        #                 this.endResponse_(negotiateMimeType);
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
