module CrystalInsideFort
  module MODEL
    class FileManager
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

      def files
        return @files.each_value
      end

      #  **
      #  * check for existance of file
      #  *
      #  * @param {string} fieldName
      #  * @returns
      #  * @memberof FileManager
      #  *
      def isExist(fieldName : String)
        return @files.has_key(fieldName)
      end

      # **
      # * return the file
      # *
      # * @param {string} fieldName
      # * @returns
      # * @memberof FileManager
      # *
      def getFile(fieldName : String)
        return @files[fieldName]
      end

      # **
      # * saves file to supplied path
      # *
      # * @param {string} fieldName
      # * @param {string} pathToSave
      # * @returns
      # * @memberof FileManager
      # *
      def saveTo(field_name : String, path_to_save : String)
        # return Fs.copy(this.files_[field_name].path, path_to_save)
      end
    end
  end
end
