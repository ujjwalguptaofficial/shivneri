require "spec"
require "../src/general"
require "http/client"

BROWSER_ACCEPT = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"

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

  def post(url : String, headers)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post(url, headers)
  end

  def post(url : String, headers, body)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post(url, headers, body)
  end

  def option(url : String, headers, body)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.options(url, headers, body)
  end

  def put(url : String)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.put url
  end
end

app = init_app()
