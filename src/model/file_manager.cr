module Shivneri
  module MODEL
    struct FileManager
      files : Hash(String, HttpFile)

      def initialize(value)
        @files = value
      end

      def initialize
        @files = {} of String => HttpFile
      end

      def add_file(file : HttpFile)
        @files[file.field_name] = file
      end

      #
      # **
      # * get total no of files
      # *
      # * @returns - number
      # * @memberof FileManager
      # *
      #
      def count
        return @files.size
      end

      def all
        return @files.each_value
      end

      #  **
      #  * check for existance of file
      #  *
      #  * @param {string} fieldName
      #  * @returns
      #  * @memberof FileManager
      #  *
      def is_exist(fieldName : String)
        return @files.has_key?(fieldName)
      end

      def [](field_name : String)
        return @files[field_name]
      end

      # **
      # * saves file to supplied path
      # *
      # * @param {string} fieldName
      # * @param {string} pathToSave
      # * @returns
      # * @memberof FileManager
      # *
      def save_to(field_name : String, path_to_save : String)
        # return Fs.copy(this.files_[field_name].path, path_to_save)
        new_file = File.new(path_to_save, "w")
        File.open(@files[field_name].path, "r") do |file|
          bytes_read = 1
          while bytes_read > 0
            bytes_read = IO.copy(file, new_file, 16384) # 16kb at a time
            Fiber.yield
          end
        end
      end
    end
  end
end
