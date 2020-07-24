module Shivneri
  module MODEL
    class ErrorHandler
      def on_server_error(ex : Exception) : String
        errMessage = "<h1>internal server error</h1>
                <h3>message : #{ex.message}</h3>"
        # if (ex.callstack)
        errMessage += "<p><b>stacktrace:</b> #{ex.callstack.as(Exception::CallStack).printable_backtrace}</p>"
        # end
        return errMessage
      end

      def on_bad_request(value : String | Exception) : String
        errMessage = "<h1>Bad Request</h1>"
        if (typeof(value) == "String")
          errMessage += "<h3>message : #{value} </h3>"
        else
          errMessage += "<h3>message : #{value.as(Exception).message} </h3><p><b>stacktrace:</b> #{value.callstack.as(Exception::CallStack).printable_backtrace}</p>"
        end
        return errMessage
      end

      def on_forbidden_request : String
        errMessage = "<h1>Forbidden</h1>"
        return errMessage
      end

      def on_not_acceptable_request : String
        errMessage = "<h1>Not Acceptable</h1>"
        return errMessage
      end

      def on_method_not_allowed : String
        errMessage = "<h1>Method Not allowed.</h1>"
        return errMessage
      end

      def on_not_found(url : String) : String
        errMessage = "<h1>The requested resource #{url} was not found.</h1>"
      end
    end
  end
end
