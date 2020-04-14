require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/user")
  
  it "/add user" do
    response = http_client.post("/")
    response.status_code.should eq 200
    response.body.should eq ""
  end

  it "/get user with id 2" do
    response = http_client.get("/2")
    response.status_code.should eq 200
    response.body.should eq "2"
  end

end
