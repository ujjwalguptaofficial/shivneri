require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "CookieController" do
  cookie_string = ""
  http_client = HttpClient.new(ENV["APP_URL"] + "/cookie")
  # http_client.before_request do |request|
  #   request.headers["Set-Cookie"] = cookie_string
  # end

  it "/get not exist cookie" do
    response = http_client.get("/me")
    response.status_code.should eq 404
    response.body.should eq "cookie not found"
  end

  it "/add cookie" do
    cookie_name = "user_name"
    cookie_value_obj = {
      cookie_value: "ujjwal",
    }
    response = http_client.post("/#{cookie_name}", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
    }, (cookie_value_obj).to_json)
    response.status_code.should eq 200
    body = JSON.parse(response.body).as_h
    body["name"].should eq "user_name"
    body["value"].should eq "ujjwal"
    body["max_age"].should eq 5000
    body["http_only"].should eq false
    body["path"].should eq "/"
    cookies = HTTP::Cookies.from_headers(response.headers)
    cookies[cookie_name]?.as(HTTP::Cookie).value.should eq cookie_value_obj[:cookie_value]
    cookies[cookie_name]?.as(HTTP::Cookie).path.should eq "/"
    cookies[cookie_name]?.as(HTTP::Cookie).secure.should eq false
    cookies[cookie_name]?.as(HTTP::Cookie).http_only.should eq false
    cookie_string = response.headers["Set-Cookie"]
  end

  it "/get cookie" do
    response = http_client.get("/user_name", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    body = JSON.parse(response.body).as_h
    body["name"].should eq "user_name"
    body["value"].should eq "ujjwal"
  end

  it "/put cookie" do
    cookie_name = "user_name"
    cookie_value_obj = {
      cookie_value: "ujjwal_gupta",
    }
    response = http_client.put("/#{cookie_name}", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, (cookie_value_obj).to_json)
    response.status_code.should eq 200
    body = JSON.parse(response.body).as_h
    body["name"].should eq "user_name"
    body["value"].should eq "ujjwal_gupta"
    body["max_age"].should eq 3600
    body["http_only"].should eq false
    body["path"].should eq "/"
    cookies = HTTP::Cookies.from_headers(response.headers)
    cookies[cookie_name]?.as(HTTP::Cookie).value.should eq cookie_value_obj[:cookie_value]
    cookies[cookie_name]?.as(HTTP::Cookie).path.should eq "/"
    cookies[cookie_name]?.as(HTTP::Cookie).secure.should eq false
    cookies[cookie_name]?.as(HTTP::Cookie).http_only.should eq false
    cookie_string = response.headers["Set-Cookie"]
  end

  it "/get cookie after update" do
    response = http_client.get("/user_name", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    body = JSON.parse(response.body).as_h
    body["name"].should eq "user_name"
    body["value"].should eq "ujjwal_gupta"
  end

  it "/delete cookie" do
    cookie_name = "user_name"
    response = http_client.delete("/user_name", HTTP::Headers{
      "Accept" => "*/*",
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    cookie_string = response.headers["Set-Cookie"]
    cookies = HTTP::Cookies.from_headers(response.headers)
    puts "cookies #{cookie_string}"
    cookies[cookie_name]?.as(HTTP::Cookie).path.should eq "/"
    cookies[cookie_name]?.as(HTTP::Cookie).secure.should eq false
    cookies[cookie_name]?.as(HTTP::Cookie).http_only.should eq false
    # cookies[cookie_name]?.as(HTTP::Cookie).expires.should eq ""
    status = (cookie_string.includes? "Expires=1900-01-01 00:00:00 UTC; Max-Age=-1;")
    status.should eq true
    response.body.should eq "deleted"
  end

  # it "/get cookie after delete" do
  #   response = http_client.get("/user_name", HTTP::Headers{
  #     "Cookie" => cookie_string,
  #   })
  #   response.status_code.should eq 404
  # end
end
