require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"])

  it "/static/" do
    response = http_client.get("/static/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/static/assets/" do
    response = http_client.get("/static/assets/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "/static/scripts/bundle.js" do
    response = http_client.get("/static/scripts/bundle.js")
    response.status_code.should eq 200
    response.content_type.should eq "application/javascript"
    response.body.should eq "var sayHi = () => {\n  alert('say hi');\n}"
  end
end
