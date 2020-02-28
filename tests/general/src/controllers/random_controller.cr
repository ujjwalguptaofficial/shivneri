module General
  class RandomController < Controller
    @[DefaultWorker]
    def format
      result = format_result({
        "application/json" => {result: "hello world"}.to_json,
        MIME_TYPE["text"]  => "hello world",
        MIME_TYPE["html"]  => "<p>hello world</p>", # MIME_TYPE["text"] => ->{
      })
      return result
    end

    @[Worker]
    @[Route("/file")]
    def getFile
      path_location = File.join(Dir.current, "contents/JsStore_16_16.png")
      return file_result(path_location)
    end

    @[Worker]
    def form
      json_result({
        body:  body,
        query: query,
      })
    end

    #   @[Worker]
    #   def redirect
    #     redirect_result("html")
    #   end
  end
end
