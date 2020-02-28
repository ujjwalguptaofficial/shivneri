require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"])

  it "" do
    response = http_client.get("")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/" do
    response = http_client.get("/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/assets/" do
    response = http_client.get("/assets/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/scripts/bundle.js" do
    response = http_client.get("/scripts/bundle.js")
    response.status_code.should eq 200
    response.content_type.should eq "application/javascript"
    response.body.should eq "var sayHi = () => {\n  alert('say hi');\n}"
  end

  it "/assets/scripts/bundle.js" do
    response = http_client.get("/assets/scripts/bundle.js")
    response.status_code.should eq 404
  end

  it "/index.html" do
    response = http_client.get("/index.html")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end
end
