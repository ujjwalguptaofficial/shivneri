module CrystalInsideFort
  module MODEL
    class ErrorHandler
      def on_server_error(ex : Exception) : String
        errMessage = "<h1>internal server error</h1>
                <h3>message : #{ex.message}</h3>"
        if (ex.callstack)
          errMessage += "<p><b>stacktrace:</b> #{ex.callstack.as(CallStack).printable_backtrace}</p>"
        end
        return errMessage
      end
    end
  end
end
