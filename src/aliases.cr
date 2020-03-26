module Shivneri
  module ALIAS
    alias ComponentResult = Nil | HttpResult
    alias FolderMap = NamedTuple(path_alias: String, path: String)
    alias FileInfo = NamedTuple(file: String, folder: String)
    alias FileResultInfo = NamedTuple(file_path: String, should_download: Bool)
    alias StringConvertableType = Int32 | UInt32 | Int16 | UInt16 | Int64 | UInt64 | Int8 | UInt8 | Bool | Char | Float32 | Float64 | Nil | JSON::Any
    # alias TypeOfAny = Nil | Bool | Int64 | Float64 | String | Array(JSON::Any) | Hash(String, JSON::Any)
    alias MessagePayload = NamedTuple(event_name: String, data: String, data_type: String)
    alias NumberType = Int32 | UInt32 | Int16 | UInt16 | Int64 | UInt64 | Int8 | UInt8 | Float32 | Float64
    
  end
end
