require "../spec_helper.cr"
require "../../src/controllers/default_controller"
describe "DefaultController" do
  http_client = HttpClient.new

  Spec.before_suite do
    http_client = HttpClient.new(ENV["APP_URL"] + "/home")
  end

  it "/json + browser accept setting" do
    response = http_client.get("/json", HTTP::Headers{
      "Accept" => BROWSER_ACCEPT,
    })
    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    response.headers["x-powered-by"]?.should eq "fort"
    {"key" => "hello", "value" => "world"}.should eq JSON.parse(response.body)
  end

  it "/json" do
    response = http_client.get("/json", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    response.headers["x-powered-by"]?.should eq "fort"
    {"key" => "hello", "value" => "world"}.should eq JSON.parse(response.body)
  end

  it "/json with text/plain" do
    response = http_client.get("/json", HTTP::Headers{
      "Accept" => "text/plain",
    })
    response.status_code.should eq 406
    response.content_type.should eq "text/html"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.should eq "<h1>Not Acceptable</h1>"
  end
end
