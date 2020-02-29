require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "SessionController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/session")
  cookie_string = ""

  it "/get_all" do
    response = http_client.get("/get_all")
    response.status_code.should eq 200
    response.body.should eq "{\"value\":{}}"
  end

  it "/is_exist" do
    response = http_client.get("/exist?key=id")
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.body.should eq "key is not found"
  end

  it "/get" do
    response = http_client.get("/get?key=id")
    response.status_code.should eq 200
    response.body.should eq "{\"value\":null}"
  end

  it "/add" do
    response = http_client.post("/add", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
    }, {
      key:   "id",
      value: 5,
    }.to_json)
    cookie_string = response.headers["Set-Cookie"]
    response.status_code.should eq 200
    response.body.should eq "saved"
  end

  it "/add" do
    response = http_client.post("/add", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      key:   "hello",
      value: "world",
    }.to_json)
    # cookie_string = response.headers["Set-Cookie"]
    response.status_code.should eq 200
    response.body.should eq "saved"
  end

  it "/is_exist" do
    puts "cmy ookies #{cookie_string}"
    response = http_client.get("/exist?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.body.should eq "key is found"
  end

  it "/get" do
    response = http_client.get("/get?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":5}"
  end

  it "/update" do
    response = http_client.post("/update", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      key:   "id",
      value: 6,
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "updated"
  end

  it "/get" do
    response = http_client.get("/get?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":6}"
  end

  it "/remove" do
    response = http_client.get("/remove?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "removed"
  end

  it "/is_exist" do
    response = http_client.get("/exist?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.body.should eq "key is not found"
  end

  it "/get" do
    response = http_client.get("/get?key=id", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":null}"
  end

  it "/get for keys which is not deleted" do
    response = http_client.get("/get?key=hello", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":\"world\"}"
  end

  it "/add many" do
    response = http_client.post("/add-many", HTTP::Headers{
      "Accept"       => "*/*",
      "Content-Type" => "application/json",
      "Cookie"       => cookie_string,
    }, {
      key1:   "hello",
      value1: "world",
      key2:   "ujjwal",
      value2: "gupta",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "saved"
  end

  it "/get_all" do
    response = http_client.get("/get_all", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":{\"hello\":\"world\",\"ujjwal\":\"gupta\"}}"
  end

  it "/clear" do
    response = http_client.get("/clear", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "cleared"
  end

  it "/get_all after clearing" do
    response = http_client.get("/get_all", HTTP::Headers{
      "Cookie" => cookie_string,
    })
    response.status_code.should eq 200
    response.body.should eq "{\"value\":{}}"
  end
end
