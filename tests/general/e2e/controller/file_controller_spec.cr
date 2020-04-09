require "../spec_helper.cr"
require "../../src/controllers/default_controller"

describe "UserController" do
  http_client = HttpClient.new(ENV["APP_URL"] + "/file")

  it "/scripts/bundle.js" do
    response = http_client.get("/scripts/bundle.js")
    response.status_code.should eq 200
    response.content_type.should eq "application/javascript"
    response.body.should eq "var sayHi = () => {\n  alert('say hi');\n}"
  end

  it "/scripts/bundle" do
    response = http_client.get("/scripts/bundle")
    response.status_code.should eq 404
  end

  it "/scripts/bundle.fgh" do
    response = http_client.get("/scripts/bundle.fgh")
    response.status_code.should eq 404
  end

  it "/scripts/bundle.jsf" do
    response = http_client.get("/scripts/bundle.jsf")
    response.status_code.should eq 404
  end

  it "/upload without any file" do
    response = http_client.post("/upload", HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json",
    }, nil)
    response.status_code.should eq 400
  end

  # it "/upload" do
  #   IO.pipe do |reader, writer|
  #     channel = Channel(String).new(1)

  #     spawn do
  #       HTTP::FormData.build(writer) do |formdata|
  #         channel.send(formdata.content_type)

  #         formdata.field("name", "fort")
  #         File.open(File.join(Dir.current, "static/fort_js_logo_200_137.png")) do |file|
  #           metadata = HTTP::FormData::FileMetadata.new(filename: "fort_js_logo_200_137.png")
  #           headers = HTTP::Headers{"Content-Type" => "image/png"}
  #           formdata.file("file", file, metadata, headers)
  #         end
  #       end

  #       writer.close
  #     end

  #     headers = HTTP::Headers{"Content-Type" => channel.receive}
  #     response = http_client.post("/upload", body: reader, headers: headers)
  #     response.status_code.should eq 200
  #     response.body.should eq "i am allowed"
  #   end
  # end
end
