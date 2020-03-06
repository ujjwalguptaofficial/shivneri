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

  it "/add user" do
    response = http_client.post("/", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      name:     "angela",
      address:  "newyork street 5 america",
      email:    "angela@mg.com",
      gender:   "female",
      password: "hiangela",
    }.to_json)
    response.status_code.should eq 201
    response.body.should eq "{\"id\":2,\"name\":\"angela\",\"gender\":\"female\",\"password\":\"hiangela\",\"email\":\"angela@mg.com\",\"address\":\"newyork street 5 america\"}"
    # cookie_string = response.headers["Set-Cookie"]
  end

  it "/add user with invalid data" do
    response = http_client.post("/", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      # name:     "angela",
      address:  "newyork street 5 america",
      email:    "angela@mg.com",
      gender:   "female",
      password: "hiangela",
    }.to_json)
    response.status_code.should eq 400
    response.body.should eq "name should be minimum 5 characters"
    # cookie_string = response.headers["Set-Cookie"]
  end

  it "/user count" do
    response = http_client.get("/count", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "2"
    # JSON.parse(response.body).as_h.size.should eq 2
  end

  it "/patch" do
    response = http_client.patch("/", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 405
    response.headers["allow"]?.should eq "GET,POST,PUT"
  end

  it "/update user" do
    response = http_client.put("/", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      id:       2,
      name:     "angela yu",
      address:  "newyork street 5 america",
      email:    "angela@mg.com",
      gender:   "female",
      password: "hiangela",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "user updated"
  end

  it "/get user with id 2" do
    response = http_client.get("/2", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"id\":2,\"name\":\"angela yu\",\"gender\":\"female\",\"password\":\"hiangela\",\"email\":\"angela@mg.com\",\"address\":\"newyork street 5 america\"}"
    # JSON.parse(response.body).as_h.size.should eq 2
  end

  it "/update user with invalid id" do
    response = http_client.put("/", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      id:       5,
      name:     "angela yu",
      address:  "newyork street 5 america",
      email:    "angela@mg.com",
      gender:   "female",
      password: "hiangela",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "invalid user"
  end

  it "/delete" do
    response = http_client.delete("/2", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "user deleted"
  end

  it "/get user with id 2" do
    response = http_client.get("/2", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq ""
  end

  it "/get shield counter" do
    response = http_client.get("/shield/count", HTTP::Headers{
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "12"
  end

  it "/thrown by shield using header counter" do
    response = http_client.get("/", HTTP::Headers{
      "Content-Type"              => "application/json",
      "Cookie"                    => cookie_string,
      "throw_exception_by_shield" => "true",
    })
    response.status_code.should eq 500
    response.body.includes?("thrown by shield").should eq true
  end

  it "/logout" do
    response = HttpClient.new(ENV["APP_URL"] + "/home/").get("log_out", HTTP::Headers{
      "Content-Type" => "application/json",
    })
    # response.status_code.should eq 200
    response.body.should eq "Logged out"
  end

  it "/access user after logout" do
    response = http_client.post("/?guard_injection_test=true", HTTP::Headers{
      "Accept" => "*/*",
      # "Content-Type" => "application/json",
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 302
    response.body.should eq ""
  end
end
