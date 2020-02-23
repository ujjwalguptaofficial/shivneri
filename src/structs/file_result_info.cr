module CrystalInsideFort
  module STRUCT
    struct FileResultInfo
      property path, should_download, name

      def initialize(@path : String, @should_download : Bool, @name : String)
      end

      #   def initialize(path, file_name = nil)
      #     @should_download = false
      #   end

    end
  end
end
