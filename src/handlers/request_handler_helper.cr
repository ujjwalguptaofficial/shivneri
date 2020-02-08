require "../fort_global"
require "../constants"
require "../hashes/index"
require "http"

module CrystalInsideFort
  module Handlers
    include HASHES

    class RequestHandlerHelper
      protected def runWallOutGoing
        #   outgoingResults: Array<Promise<any>> = [];
        # reverseLoop(this.wallInstances, (value: Wall) => {
        #     const methodArgsValues = InjectorHandler.getMethodValues(value.constructor.name, 'onOutgoing');
        #     outgoingResults.push(value.onOutgoing(methodArgsValues));
        # });
        # return Promise.all(outgoingResults);
      end

      protected def onErrorOccured(error : Exception)
        # puts typeof(error)
        errMessage : String = ""
        begin
          self.runWallOutGoing
          errMessage = FortGlobal.error_handler.new.on_server_error(error)
        rescue ex
          errMessage = ""
          # ex.message
        end
        # @response.headers[CONSTANTS.content_type] = MIME_TYPE["html"]
        # @response.respond_with_status(500, errMessage)
        @response.content_type = MIME_TYPE["html"]
        @response.status = HTTP::Status::INTERNAL_SERVER_ERROR
        @response.print(errMessage)
      end
    end
  end
end
