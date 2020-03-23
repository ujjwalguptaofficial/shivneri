require "./request_handler_helper"

module Shivneri
  module Handlers
    class FileHandler < RequestHandlerHelper
      private def get_file_info_from_url(url_path : String)
        splitted_path_by_slash = url_path.split("/")
        if (splitted_path_by_slash.size > 2 || File.extname(url_path).empty? == false)
          return {
            file:   splitted_path_by_slash[2, splitted_path_by_slash.size].join("/"),
            folder: splitted_path_by_slash[1],
          }
        end
        return {
          file:   "",
          folder: splitted_path_by_slash[1],
        }
      end

      private def check_for_folder_allow_and_return_path(url_path : String)
        get_abs_path = ->(file_info : ALIAS::FileInfo) {
          folder = FortGlobal.folders.find { |qry| qry[:path_alias] == file_info[:folder] }
          if (folder != nil)
            return File.join(folder.as(ALIAS::FolderMap)[:path], file_info[:file])
          end
          return nil
        }
        abs_path = get_abs_path.call(self.get_file_info_from_url(url_path))
        if (abs_path == nil)
          abs_path = get_abs_path.call({
            file:   url_path,
            folder: "/",
          })
        end
        return abs_path
      end

      protected def handle_file_request(url_path : String)
        extension = File.extname(url_path)
        abs_file_path = self.check_for_folder_allow_and_return_path(url_path)
        if (abs_file_path != nil)
          self.handle_file_request_from_absolute_path(abs_file_path.as(String), extension)
        else
          self.on_not_found
        end
      end

      protected def handle_file_request_from_absolute_path(absolute_path : String, file_type : String)
        if (File.exists?(absolute_path))
          file_info = File.info(absolute_path)
          if (file_info.directory?)
            self.handle_file_request_for_folder_path(absolute_path)
          else
            self.send_file(absolute_path, file_type, file_info)
          end
        else
          self.on_not_found
        end
      end

      private def handle_file_request_for_folder_path(absolute_path : String)
        absolute_path = File.join(absolute_path, "index.html")
        file_info = File.info(absolute_path)
        if (file_info != nil)
          self.send_file(absolute_path, MIME_TYPE["html"], file_info)
        else
          self.on_not_found
        end
      end

      private def send_file_as_response(file_path : String, mime_type : String)
        response.content_type = mime_type
        response.status = HTTP::Status::OK
        begin
          File.open(file_path) do |file|
            bytes_read = 1
            while bytes_read > 0
              bytes_read = IO.copy(file, response, 16384) # 16kb at a time
              Fiber.yield
            end
          end
        rescue exception
          self.on_error_occured(exception)
        end
      end

      private def get_mime_type_from_file_type(file_type : String)
        if (file_type[0] == '.')
          return MIME.from_extension(file_type)
        end
        return file_type
      end

      macro is_env_production
        return true
      end

      {% if true %}
        private def send_file(file_path : String, file_type : String, file_info : File::Info)
          begin
            self.run_wall_out_going
            self.send_file_as_response(file_path, self.get_mime_type_from_file_type(file_type))
          rescue exception
            self.on_error_occured(exception)
          end
        end
      {% else %}
        private def send_file(file_path : String, file_type : String, file_info : File::Info)
          begin
            self.run_wall_out_going
            self.send_file_as_response(file_path, self.get_mime_type_from_file_type(file_type))
          rescue exception
            self.on_error_occured(exception)
          end
        end
      {% end %}
    end
  end
end
