module CrystalInsideFort
  module MODEL
    class ErrorHandler
      def on_server_error(ex : Exception) : String
        errMessage = "<h1>internal server error</h1>
                <h3>message : #{ex.message}</h3>"
        # if (ex.callstack)
        errMessage += "<p><b>stacktrace:</b> #{ex.callstack.as(CallStack).printable_backtrace}</p>"
        # end
        return errMessage
      end

      def on_bad_request(value : String | Exception) : String
        errMessage = "<h1>Bad Request</h1>"
        if (typeof(value) == "String")
          errMessage += "<h3>message : #{value} </h3>"
        else
          errMessage += "<h3>message : #{value.as(Exception).message} </h3><p><b>stacktrace:</b> #{value.callstack.as(CallStack).printable_backtrace}</p>"
        end
        return errMessage
      end
    end
  end
end
