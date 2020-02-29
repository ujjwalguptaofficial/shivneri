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

  # def before_each(&callback : HTTP::Request ->)

  # end

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

  def delete(url : String, headers)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.delete(url, headers)
  end

  def post(url : String)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post url
  end

  def post(url : String, body)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post(url, nil, body)
  end

  def post(url : String, headers : HTTP::Headers)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.post(url, headers)
  end

  def put(url : String, headers : HTTP::Headers, body)
    if (url.includes?("http") == false)
      url = @base_url + url
    end

    return HTTP::Client.put(url, headers, body)
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
