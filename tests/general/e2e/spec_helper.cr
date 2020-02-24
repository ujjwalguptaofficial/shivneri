require "spec"
require "../src/general"
require "http/client"

class HttpClient
  #  property base_url

  def initialize(@base_url : String)
  end

  def initialize
    @base_url = ""
  end

  def get(url : String)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.get url
  end

  def get(url : String, headers)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.get(url, headers)
  end

  def post(url : String)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post url
  end

  def put(url : String)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.put url
  end
end
