require "./controller_result_handler"

module CrystalInsideFort
  module Handlers
    class PostHandler < ControllerResultHandler
      getter body

      @body = {} of String => JSON::Any

      file : FileManager

      private def parse_multi_part_data
        # return promise((res, rej) => {
        #     new Multiparty.Form().parse(this.request, (err, fields, files) => {
        #         if (err) {
        #             rej(err);
        #         }
        #         else {
        #             const result: MultiPartParseResult = {
        #                 field: {},
        #                 file: {}
        #             };
        #             for (const field in fields) {
        #                 result.field[field] = fields[field].length === 1 ? fields[field][0] : fields[field];
        #             }
        #             for (const file in files) {
        #                 result.file[file] = files[file].length === 1 ? files[file][0] : files[file];
        #             }
        #             res(result);
        #         }
        #     });
        # });

        MIME::Multipart.parse(request) do |headers, io|
          headers["Content-Type"]
          io.gets_to_end
        end
      end

      protected def parse_post_data_and_set_body
        # let postData;

        contentType = ""
        if (@request.headers.has_key?(CONSTANTS.content_type))
          contentType = @request.headers[CONSTANTS.content_type]
        elsif @request.headers.has_key?("content-type")
          contentType = @request.headers["content_type"]
        end
        contentType = parse_content_type(contentType)
        puts "parsing body #{contentType}"
        if (contentType == MIME_TYPE["form_multi_part"])
          # const result = await this.parseMultiPartData_();
          # postData = result.field;
          # this.file = new FileManager(result.file);
          # @parse_multi_part_data
        else
          #     this.file = new FileManager({});
          puts "parsing body 1"
          case contentType
          when MIME_TYPE["json"]
            #   postData = JsonHelper.parse(bodyDataAsString);
            puts "parsing body json"
            @body = JSON.parse(@request.body.as(IO)).as_h
          when MIME_TYPE["form_url_encoded"]
            @body = JSON.parse(@request.body.as(IO).gets_to_end)
            #   case MIME_TYPE.Xml:
            #       postData = new (FortGlobal as any).xmlParser().parse(bodyDataAsString);
            #       break;
          end
        end

        # return postData;

      end
    end
  end
end
