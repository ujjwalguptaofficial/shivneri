require "../guards/invalid_injection_guard"

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

    @[Worker]
    def error
      query["test_key"]
      return text_result("OK")
    end

    @[Worker("GET")]
    @[Route("/download")]
    def download
      path_location = File.join(Dir.current, "contents/index.html")
      return download_result(path_location)
    end

    @[Worker("POST")]
    @[Route("/download")]
    def download_with_alias
      path_location = File.join(Dir.current, "contents/index.html")
      return download_result(path_location, "alias.html")
    end

    @[Worker]
    @[Route("/file")]
    def get_file
      path_location = File.join(Dir.current, "contents/JsStore_16_16.png")
      return file_result(path_location)
    end

    @[Worker]
    @[Guards(InvalidInjectionGuard)]
    def invalid_guard_injection
      return text_result ""
    end
  end
end
