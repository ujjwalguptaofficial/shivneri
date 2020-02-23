module CrystalInsideFort
  module ALIAS
    alias ComponentResult = Nil | HttpResult
    alias FolderMap = NamedTuple(path_alias: String, path: String)
    alias FileInfo = NamedTuple(file: String, folder: String)
    alias FileResultInfo = NamedTuple(file_path: String, should_download: Bool)
    # alias TypeOfAny = Nil | Bool | Int64 | Float64 | String | Array(JSON::Any) | Hash(String, JSON::Any)
  end
end
