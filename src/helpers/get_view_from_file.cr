module Shivneri
  module HELPER
    view_cache = {} of String => String

    private def read_view(option : ViewReadOption) : Async(String)
      return Async(String).new(->{
        path_of_view = File.join(FortGlobal.view_path, option.file_location)
        result = File.read(path_of_view)
        #   if (option.mapView != null)
        #     return option.mapView(result)
        #   end
        return result
      })
    end

    # {% if !ENV["CRYSTAL_ENV"] === "production" %}
    # def get_view_from_file(option : ViewReadOption) : Async(String | _)
    #   if (view_cache[option.fileLocation] == null)
    #     view_cache[option.fileLocation] = await read_view(option)
    #   end
    #   return view_cache[option.fileLocation]
    # end
    # {% else %}
    def get_view_from_file(option : ViewReadOption) : Async(String)
      return Async(String).new(->{
        return read_view(option).await
      })
    end
    # {% end %}
  end
end
