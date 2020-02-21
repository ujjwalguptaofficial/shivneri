module CrystalInsideFort
  module ALIAS
    alias ComponentResult = Nil | HttpResult
    alias FolderMap = NamedTuple(path_alias: String, path: String)
    alias FileInfo = NamedTuple(file: String, folder: String)
  end
end
