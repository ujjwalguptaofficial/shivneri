require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"])

  it "/contents/" do
    response = http_client.get("/contents/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/contents" do
    response = http_client.get("/contents")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/contents/JsStore_16_16.png" do
    response = http_client.get("/contents/JsStore_16_16.png")
    response.status_code.should eq 200
    response.content_type.should eq "image/png"
  end
end
