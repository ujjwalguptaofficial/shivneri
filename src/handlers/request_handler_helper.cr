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

      protected def onErrorOccured(error)
        errMessage : String = ""
        begin
          self.runWallOutGoing
          # errMessage = FortGlobal.errorHandler.new.onServerError(error)
        rescue ex
          errMessage = ""
          # ex.message
        end
        @response.headers[CONSTANTS.content_type] = MIME_TYPE["html"]
        @response.respond_with_status(500, errMessage)
      end
    end
  end
end
