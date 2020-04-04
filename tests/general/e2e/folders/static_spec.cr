require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"])
  etag = ""
  last_modified = ""
  it "/static/" do
    response = http_client.get("/static/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    if (ENV["CRYSTAL_ENV"]? == "production")
      response.headers.has_key?("Etag").should eq true
      response.headers.has_key?("Last-Modified").should eq true
      etag = response.headers["Etag"]
      last_modified = response.headers["Last-Modified"]
    else
      response.headers.has_key?("Etag").should eq false
      response.headers.has_key?("Last-Modified").should eq false
    end
  end

  it "/static/assets/" do
    response = http_client.get("/static/assets/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/static/assets/ with etag" do
    if (ENV["CRYSTAL_ENV"]? == "production")
      response = http_client.get("/static/assets/", HTTP::Headers{
        "If-None-Match" => etag,
      })
      response.status_code.should eq 304
      response.content_type.should eq nil
    else
      response = http_client.get("/static/assets/", HTTP::Headers{
        "If-None-Match" => etag,
      })
      response.status_code.should eq 200
      response.content_type.should eq "text/html"
    end
  end

  it "/static/assets/ with last_modified" do
    if (ENV["CRYSTAL_ENV"]? == "production")
      response = http_client.get("/static/assets/", HTTP::Headers{
        "If-Modified-Since" => last_modified,
      })
      response.status_code.should eq 304
      response.content_type.should eq nil
    else
      response = http_client.get("/static/assets/", HTTP::Headers{
        "If-Modified-Since" => last_modified,
      })
      response.status_code.should eq 200
      response.content_type.should eq "text/html"
    end
  end

  it "/static/scripts/bundle.js" do
    response = http_client.get("/static/scripts/bundle.js")
    response.status_code.should eq 200
    response.content_type.should eq "application/javascript"
    response.body.should eq "var sayHi = () => {\n  alert('say hi');\n}"
  end
end
