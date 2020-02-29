require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "CookieController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/cookie")

  it "/get not exist cookie" do
    response = http_client.get("/me")
    response.status_code.should eq 404
    response.body.should eq "cookie not found"
  end

  it "/add cookie" do
    cookie_name = "user_name"
    response = http_client.post("/#{cookie_name}", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
    }, ({
      cookie_value: "ujjwal",
    }).to_json)
    response.status_code.should eq 200
    response.body.should eq "cookie not found"
  end

  #   it "/access user without login" do
  #     response = http_client.get("/")
  #     response.status_code.should eq 302
  #     response.body.should eq ""
  #   end
end
