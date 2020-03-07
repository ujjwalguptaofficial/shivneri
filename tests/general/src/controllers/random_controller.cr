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

    @[Worker]
    @[Inject("as_body")]
    @[ExpectBody(NamedTuple(id1: Int32, id2: Int64, id3: Float32, id4: Float64,
      name: String, char: Char, int_8: Int8, uint_8: UInt8, int_16: Int16,
      uint_16: UInt16, uint_32: UInt32, uint_64: UInt64, bool: Bool))]
    def tuple_convert_test(data)
      my_body = {id1:     data[:id1],
                 id2:     data[:id2],
                 id3:     data[:id3],
                 id4:     data[:id4],
                 name:    data[:name],
                 char:    data[:char].to_s,
                 int_8:   data[:int_8],
                 uint_8:  data[:uint_8],
                 int_16:  data[:int_16],
                 uint_16: data[:uint_16],
                 uint_32: data[:uint_32],
                 uint_64: data[:uint_64],
                 bool:    data[:bool],
      }
      return json_result my_body
    end
  end
end
