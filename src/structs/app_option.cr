require "../aliases"

module Shivneri
  module STRUCT
    struct AppOption
      property folders, port

      def initialize
        @folders = [] of ALIAS::FolderMap
        @port = 4000
      end
    end
  end
end
