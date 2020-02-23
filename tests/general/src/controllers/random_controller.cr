module General
  class RandomController < Controller
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
