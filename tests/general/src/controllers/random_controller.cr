module General
  class RandomController < Controller
    @[DefaultWorker]
    def format
      #  result = {
      #     statusCode: HTTP_STATUS_CODE.Ok,
      #     responseFormat: {
      #         [MIME_TYPE.Json]: () => {
      #             return { result: "hello world" }
      #         },
      #         [MIME_TYPE.Html]: () => {
      #             return "<p>hello world</p>"
      #         },
      #         [MIME_TYPE.Text]: () => {
      #             return "hello world"
      #         }
      #     }
      # } ;
      result = format_result({
        "application/json" => {result: "hello world"}.to_json,
        MIME_TYPE["text"]  => "hello world",
        MIME_TYPE["html"]  => "<p>hello world</p>" # MIME_TYPE["text"] => ->{
      #   return "hello world"
      # },
      # MIME_TYPE["html"] => ->{
      #   return "<p>hello world</p>"
      # },
      })
      return result
    end

    @[Worker]
    @[Route("/file")]
    def getFile
      path_location = File.join(Dir.current, "contents/JsStore_16_16.png")
      return file_result(path_location)
    end

    #   @[Worker]
    #   def post
    #     json_result(body)
    #   end

    #   @[Worker]
    #   def redirect
    #     redirect_result("html")
    #   end
  end
end
