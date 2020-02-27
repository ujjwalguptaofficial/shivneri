require "./controller_result_handler"

module Shivneri
  module Handlers
    class PostHandler < ControllerResultHandler
      getter body, file

      @body = {} of String => JSON::Any

      @file : FileManager = FileManager.new

      private def parse_multi_part_data
        HTTP::FormData.parse(@request) do |part|
          case part.headers["Content-Type"]
          when MIME_TYPE["json"]
            @body.merge!(JSON.parse(part.body).as_h)
          when MIME_TYPE["form_url_encoded"]
            HTTP::Params.parse(part.body.gets_to_end).each do |key, val|
              @body[key] = JSON::Any.new(val)
            end
          else
            if (part.filename == nil || part.filename.as(String).empty?)
              return
            end
            tmp_file = File.tempfile(part.name)
            File.open(tmp_file.path, "w") do |file|
              IO.copy(part.body, file)
            end
            @file.add_file(HttpFile.new(part, tmp_file.path))
          end
        end
      end

      protected def parse_post_data_and_set_body
        contentType = ""
        if (@request.headers.has_key?(CONSTANTS.content_type))
          contentType = @request.headers[CONSTANTS.content_type]
        elsif @request.headers.has_key?("content-type")
          contentType = @request.headers["content_type"]
        end
        contentType = parse_content_type(contentType)
        if (contentType == MIME_TYPE["form_multi_part"])
          self.parse_multi_part_data
        else
          case contentType
          when MIME_TYPE["json"]
            @body = JSON.parse(@request.body.as(IO)).as_h
          when MIME_TYPE["xml"]
            puts "parsing body xml"
            # @body = XML.parse(@request.body.as(IO)).as_h
          when MIME_TYPE["form_url_encoded"]
            HTTP::Params.parse(@request.body.as(IO).gets_to_end).each do |key, val|
              @body[key] = JSON::Any.new(val)
            end
            #   case MIME_TYPE.Xml:
            #       postData = new (FortGlobal as any).xmlParser().parse(bodyDataAsString);
            #       break;
          end
        end
      end
    end
  end
end
