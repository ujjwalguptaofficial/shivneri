require "../spec_helper.cr"
require "../../src/controllers/default_controller"
describe "HomeController" do
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

  #   it "/json with http:option" do
  #     response = http_client.option("/json", HTTP::Headers{
  #       "Accept"       => "application/json",
  #       "Content-Type" => "application/json",
  #     }, {
  #       key: "hello",
  #     }.to_json)
  #     response.status_code.should eq 200
  #     # response.headers["allow"]?.should eq "POST"
  #     response.body.should eq ""
  #   end

  it "/json with text/plain" do
    response = http_client.get("/json", HTTP::Headers{
      "Accept" => "text/plain",
    })
    response.status_code.should eq 406
    response.content_type.should eq "text/html"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.should eq "<h1>Not Acceptable</h1>"
  end

  it "/html" do
    response = http_client.get("/html", HTTP::Headers{
      "Accept" => "text/html",
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.should eq "<h1>hey there i am html</h1>"
  end

  it "/html + browser accept setting" do
    response = http_client.get("/html", HTTP::Headers{
      "Accept" => BROWSER_ACCEPT,
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.body.should eq "<h1>hey there i am html</h1>"
  end

  it "/html with application/json" do
    response = http_client.get("/html", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 406
    response.content_type.should eq "text/html"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.should eq "<h1>Not Acceptable</h1>"
  end

  it "/text" do
    response = http_client.get("/text", HTTP::Headers{
      "Accept" => "text/plain",
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.headers["custom-header-from-outgoing-wall"]?.should eq "*"
    response.body.should eq "text"
  end

  it "/text with post" do
    response = http_client.post("/text", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 405
  end

  it "/post with no body" do
    response = http_client.post("/post", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json",
    }, nil)
    response.status_code.should eq 200
    response.body.should eq "{\"body_data\":{}}"
  end

  it "/post with empty body" do
    response = http_client.post("/post", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json",
    }, ({} of String => String).to_json)
    response.status_code.should eq 200
    response.body.should eq "{\"body_data\":{}}"
  end

  it "/post with some body" do
    response = http_client.post("/post", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json",
    }, {
      key: "hello",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "{\"body_data\":{\"key\":\"hello\"}}"
  end

  it "/post with xml data" do
    response = http_client.post("/post", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/xml",
    }, "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
    <key>hello</key>")
    response.status_code.should eq 200
    response.body.should eq "{\"body_data\":{}}"
  end

  it "/post with http:get" do
    response = http_client.get("/post", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 405
    response.headers["allow"]?.should eq "POST"
  end

  it "/post with http:option" do
    response = http_client.option("/post", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json",
    }, {
      key: "hello",
    }.to_json)
    response.status_code.should eq 200
    response.headers["allow"]?.should eq "POST"
    response.body.should eq ""
  end

  it "/redirect" do
    response = http_client.get("/redirect")
    response.status_code.should eq 302
    response.headers["custom-header-from-outgoing-wall"]?.should eq "*"
    response.headers["location"]?.should eq "html"
    response.body.should eq ""
  end

  it "/login" do
    response = http_client.post("/login", HTTP::Headers{
      "Content-Type" => "application/json",
    }, {
      email:    "ujjwal@mg.com",
      password: "admin",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "Authenticated"
  end

  it "/get_users" do
    response = http_client.get("/get_users", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.headers.has_key?("allow").should eq false
  end

  it "/get_students" do
    response = http_client.get("/get_students", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.body.should eq "[{\"id\":1,\"name\":\"ujjwal\",\"type\":\"student\"}]"
  end

  it "/get_employees" do
    response = http_client.get("/get_employees", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.body.should eq "[{\"id\":1,\"name\":\"ujjwal\",\"type\":\"employee\"}]"
  end

  it "/text with get_body without any body" do
    response = http_client.post("/get_body", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.body.should eq "{\"name\":null,\"address\":null}"
  end

  it "/text with get_body with body - name only" do
    response = http_client.post("/get_body", HTTP::Headers{
      # "Content-Type" => "application/json",
      "Accept" => "application/json",
    }, {
      name: "ujjwal",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "{\"name\":\"ujjwal\",\"address\":null}"
  end

  it "/text with get_body with body - name & address" do
    response = http_client.post("/get_body", HTTP::Headers{
      # "Content-Type" => "application/json",
      "Accept" => "application/json",
    }, {
      name:    "ujjwal",
      address: "India",
    }.to_json)
    response.status_code.should eq 200
    response.body.should eq "{\"name\":\"ujjwal\",\"address\":\"India\"}"
  end
end
