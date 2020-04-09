require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "RandomController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/random")

  it "/ + accept:text/html" do
    response = http_client.get("/", HTTP::Headers{
      "Accept" => "text/html",
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.body.should eq "<p>hello world</p>"
  end

  it "/ + accept:text/plain" do
    response = http_client.get("/", HTTP::Headers{
      "Accept" => "text/plain",
    })
    response.status_code.should eq 200
    response.content_type.should eq "text/plain"
    response.body.should eq "hello world"
  end

  it "/ + accept:application/json" do
    response = http_client.get("/", HTTP::Headers{
      "Accept" => "application/json",
    })
    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    response.body.should eq "{\"result\":\"hello world\"}"
  end

  it "/ + accept:application/xml" do
    response = http_client.get("/", HTTP::Headers{
      "Accept" => "application/xml",
    })
    response.status_code.should eq 406
  end

  it "/form with post" do
    response = http_client.post("/form", HTTP::Headers{
      "content-type" => "application/x-www-form-urlencoded",
    }, HTTP::Params.encode({"hello" => "world"}))
    response.status_code.should eq 200
    response.body.should eq "{\"body\":{\"body_data\":{\"hello\":\"world\"}},\"query\":{\"query_data\":{}}}"
  end

  it "/form with get" do
    response = http_client.get("/form?" + HTTP::Params.encode({"hello" => "world"}))
    response.status_code.should eq 200
    response.body.should eq "{\"body\":{\"body_data\":{}},\"query\":{\"query_data\":{\"hello\":\"world\"}}}"
  end

  it "/error" do
    response = http_client.get("/error")
    response.status_code.should eq 500
    status = (response.body.includes? "Missing hash key: \"test_key\"") # == true
    status.should eq true
  end

  it "/download with get" do
    response = http_client.get("/download")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.headers["content-disposition"].should eq "attachment;filename=index.html"
  end

  it "/download with post" do
    response = http_client.post("/download", HTTP::Headers{
      "Accept" => "*/*",
    }, {
      name: "ujjwal",
    }.to_json)
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.headers["content-disposition"].should eq "attachment;filename=alias.html"
  end

  it "/file" do
    response = http_client.post("/file", {name: "u"}.to_json)
    response.status_code.should eq 200
    response.content_type.should eq "image/png"
    response.headers.has_key?("content-disposition").should eq false
  end

  it "/invalid_guard_injection" do
    response = http_client.get("/invalid_guard_injection")
    response.status_code.should eq 500
    response.content_type.should eq "text/html"
    response.body.includes?("Guard General::InvalidInjectionGuard expect some arguments in method check, use Inject annotation for dependency injection.").should eq true
  end

  it "/tuple_convert_test for get" do
    response = http_client.get("/tuple_convert_test")
    response.status_code.should eq 200
    # response.body.includes?("Guard General::InvalidInjectionGuard expect some arguments in method check, use Inject annotation for dependency injection.").should eq true
    response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \",\"int_8\":0,\"uint_8\":0,\"int_16\":0,\"uint_16\":0,\"uint_32\":0,\"uint_64\":0,\"bool\":false}"
  end

  it "/tuple_convert_test for type int32" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {id1: "ujjwal"}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'id1', should be type of Int32").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type int64" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {id2: "ujjwal"}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'id2', should be type of Int64").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type Float32" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {id3: "ujjwal"}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'id3', should be type of Float32").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type Float64" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {id4: "ujjwal"}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'id4', should be type of Float64").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type String" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {name: 0}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'name', should be type of String").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type char" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {char: 0}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'char', should be type of Char").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/tuple_convert_test for type Bool" do
    response = http_client.post("/tuple_convert_test", HTTP::Headers{
      "Content-Type" => "application/json",
      # "Cookie"       => cookie_string,
    }, {bool: "0"}.to_json)
    response.status_code.should eq 400
    response.body.includes?("Invalid value supplied for property - 'bool', should be type of Bool").should eq true
    # response.body.should eq "{\"id1\":0,\"id2\":0,\"id3\":0.0,\"id4\":0.0,\"name\":\"\",\"char\":\" \"}"
  end

  it "/big query test" do
    response = http_client.get("/big_query_test?key1=value1&key2=12&key3=true&key4=12&key5=1234.34")
    # response.status_code.should eq 200
    # response.body.includes?("Invalid value supplied for property - 'bool', should be type of Bool").should eq true
    response.body.should eq "{\"key1\":\"value1\",\"key2\":12,\"key3\":true,\"key4\":12,\"key5\":1234.34}"
  end
end
