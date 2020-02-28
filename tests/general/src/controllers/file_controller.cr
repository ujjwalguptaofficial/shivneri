module General
  class FileController < Controller
    @[Route("/scripts/{file}.js")]
    @[Worker]
    def get_scripts
      # check for file exist when there is no upload
      # Note :- do not remove this
      begin
        is_file_exist = file.is_exist("jsstore")
        file_path = File.join(Dir.current, "static/scripts/", "#{param["file"]}.js")
        return file_result(file_path)
      rescue ex
        logger.error(ex)
        return text_result("")
      end
    end

    @[Worker("POST")]
    @[Route("/upload")]
    def upload_file
      pathToSave = File.join(Dir.current, "upload/upload.png")
      logger.debug("count", self.file.count)
      field = "fort"
      if (self.file.is_exist(field) == true)
        self.file.save_to(field, pathToSave)
        return json_result({
          count:   file.count,
          message: "file saved",
          # file_list:   file.all,
          file_detail: file[field],
        })
      else
        result = {
          count:   self.file.count,
          message: "file not saved",
        }
        return json_result(result)
      end
    end
  end
end
