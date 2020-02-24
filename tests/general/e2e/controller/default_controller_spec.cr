require "../spec_helper.cr"
require "../../src/controllers/default_controller"
describe "DefaultController" do
  app = init_app()
  http_client = HttpClient.new

  Spec.before_suite do
    http_client = HttpClient.new(ENV["APP_URL"] + "/default")
  end

  it "/" do
    response = http_client.get("/")
    response.status_code.should eq 200
    response.content_type.should eq "text/html"
    response.headers["x-powered-by"]?.should eq "fort"
    response.body.tr("\n", "").tr(" ", "").should eq "<html><head><title>Welcometofort</title></head><body><h1>Index</h1></body></html>"
  end

  # it "/ with content type text/plain" do
  #   response = http_client.get("/", HTTP::Headers{
  #     "Accept" => "text/plain",
  #   })
  #   response.status_code.should eq 200
  #   response.content_type.should eq "text/plain"
  #   response.headers["x-powered-by"]?.should eq "fort"
  #   response.body.tr("\n", "").tr(" ", "").should eq "<html><head><title>Welcometofort</title></head><body><h1>Index</h1></body></html>"
  # end

  it "index1 - multiple assign" do
    response = http_client.get("/index1")
    response.status_code.should eq 200
    response.body.should eq "UjjwalGupta"
  end

  it "get friends" do
    response = http_client.get("/friends")
    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    response.body.should eq "{\"friends\":[\"mohan\",\"sohan\"]}"
  end

  it "post friends" do
    response = http_client.post("/friends")
    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    response.body.should eq "{\"friends\":[\"mohan\",\"sohan\"]}"
  end

  it "put friends" do
    response = http_client.put("/friends")
    response.status_code.should eq 405
    response.content_type.should eq "text/html"
    response.body.should eq "<h1>Method Not allowed.</h1>"
  end

  Spec.after_suite do
    app.destroy
  end
end
