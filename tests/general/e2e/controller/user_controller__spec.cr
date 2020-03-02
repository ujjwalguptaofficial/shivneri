require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/user")
  cookie_string = ""

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

  it "/login" do
    response = HttpClient.new(ENV["APP_URL"] + "/home").post("/login", HTTP::Headers{
      "Content-Type" => "application/json",
    }, {
      email:    "ujjwal@mg.com",
      password: "admin",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "Authenticated"
    cookie_string = response.headers["Set-Cookie"]
  end

  it "/guard injection test" do
    response = http_client.post("/?guard_injection_test=true", HTTP::Headers{
      "Accept" => "*/*",
      # "Content-Type" => "application/json",
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "hello injection ok in guard"
  end
end
