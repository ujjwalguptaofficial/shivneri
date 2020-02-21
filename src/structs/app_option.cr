require "../aliases"

module CrystalInsideFort
  module STRUCT
    struct AppOption
      property folders

      def initialize
        @folders = [] of ALIAS::FolderMap
      end
    end
  end
end
