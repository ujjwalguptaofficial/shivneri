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

  it "index1 - multiple assign" do
    response = http_client.get("/index1")
    response.status_code.should eq 200
    response.body.should eq "UjjwalGupta"
  end

  Spec.after_suite do
    app.destroy
  end
end
