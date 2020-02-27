require "../fort_global"
require "./file_handler"

module Shivneri
  module Handlers
    class ControllerResultHandler < FileHandler
      @controller_result : HttpResult = HttpResult.new("", "")

      private def on_termination_from_Wall(result : HttpResult | Nil)
        handle_final_result(result)
      end

      private def end_response(negotiateMimeType : String)
        # let data
        begin
          # data = getResultBasedOnMiMe(negotiateMimeType,
          #     self.controllerResult_.responseData
          #     , (type: MIME_TYPE) => {
          #         negotiateMimeType = type;
          #     }
          # );
        rescue ex
          self.on_error_occured(ex)
          return
        end
        @response.content_type = negotiateMimeType
        @response.status_code = @controller_result.status_code
        @response.print(@controller_result.response_data)
      end

      protected def on_result_from_controller(result : HttpResult)
        begin
          self.run_wall_out_going
        rescue ex
          self.on_error_occured(ex)
          return
        end
        self.handle_final_result(result)
      end

      private def handle_format_result
        response_format_result = @controller_result.response_format.as(Hash(String, String))
        response_format_mime_types = response_format_result.keys
        negotiateMimeType = self.get_content_type_from_negotiation(response_format_mime_types)
        key = response_format_mime_types.find { |qry| qry == negotiateMimeType }
        if (key != nil)
          self.end_response(response_format_result[key])
        else
          self.on_not_acceptable_request
        end
      end

      private def handle_redirect_result
        @response.headers["Location"] = @controller_result.response_data
        @response.status_code = @controller_result.status_code
        @response.close
      end

      private def handle_file_result
        file_result = @controller_result.file.as(FileResultInfo)
        file_path = file_result.path
        if (file_result.should_download == true)
          @response.headers["Content-Disposition"] = "attachment;filename=#{file_result.name}"
        end
        self.handle_file_request_from_absolute_path(file_path, MIME.from_filename(file_path))
      end

      private def handle_final_result(result : HttpResult)
        result = result || HttpResult.new("", MIME_TYPE["text"])
        @controller_result = result
        self.cookie_manager.as(CookieManager).response_cookie.each do |value|
          self.response.headers[CONSTANTS.set_cookie] = value
        end

        if (result.should_redirect == true)
          self.handle_redirect_result
        elsif (result.response_format == nil)
          if (result.file == nil)
            contentType = result.as(HttpResult).content_type || MIME_TYPE["text"]
            negotiateMimeType = self.get_content_type_from_negotiation(contentType)
            if (negotiateMimeType != nil)
              self.end_response(negotiateMimeType.as(String))
            else
              self.on_not_acceptable_request
            end
          else
            self.handle_file_result
          end
        else
          self.handle_format_result
        end
      end
    end
  end
end
