require "../spec_helper.cr"
require "../../src/controllers/default_controller"
describe "DefaultController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/user")

  it "/allow me without login" do
    response = http_client.get("/allow/me")
    response.status_code.should eq 200
    response.body.should eq "i am allowed"
  end

  it "/access user without login" do
    response = http_client.get("/")
    response.status_code.should eq 302
    response.body.should eq ""
  end
end
