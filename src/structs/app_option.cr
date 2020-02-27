require "../aliases"

module Shivneri
  module STRUCT
    struct AppOption
      property folders

      def initialize
        @folders = [] of ALIAS::FolderMap
      end
    end
  end
end
