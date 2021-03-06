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
          folder = FortGlobal.folders.find { |qry| qry[:path] == file_info[:folder] }
          if (folder != nil)
            return File.join(folder.as(ALIAS::FolderMap)[:folder], file_info[:file])
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

      private def get_etag(modification_time)
        %{W/"#{modification_time.to_unix}"}
      end

      private def is_client_has_fresh_file(etag : String, last_modified_time)
        if (request_headers["If-None-Match"]? == etag)
          return true
        elsif (if_modified_since = request_headers["If-Modified-Since"]?)
          if last_time_of_resource_from_client = HTTP.parse_time(if_modified_since)
            return last_modified_time <= last_time_of_resource_from_client + 5.second
          end
        end
        return false
      end

      {% if env("CRYSTAL_ENV") != nil && env("CRYSTAL_ENV").downcase == "production" %}
        private def send_file(file_path : String, file_type : String, file_info : File::Info)
          begin
            self.run_wall_out_going
            modification_time = file_info.modification_time
            etag = self.get_etag(modification_time)
            if (is_client_has_fresh_file(etag, modification_time))
              self.response.status_code = 304
              self.response.close
              return
            end
            self.response_headers["Etag"] = etag
            self.response_headers["Last-Modified"] = HTTP.format_time(modification_time)
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
