require "../spec_helper.cr"
require "../../src/controllers/default_controller"
describe "DefaultController" do
  http_client = HttpClient.new

  Spec.before_suite do
    http_client = HttpClient.new(ENV["APP_URL"])
  end

  it "/" do
    response = http_client.get("/")
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.should eq ""
  end

end
