require "http/server"

class Fort
  # @server = nil;
  setter port : Int32 = 4000
  setter routes = [] of NamedTuple(controllerName: String, path: String)

  # def initialize
  #   @port = 4000
  # end

  def create
    server = HTTP::Server.new do |context|
      context.response.content_type = "text/plain"
      context.response.print "Hello world! The time is #{Time.local}"
    end
    @routes.each do |route|
      puts "route controller name #{route[:controllerName]}"
    end
    address = server.bind_tcp @port
    puts "Your fort is available on http://#{address}"
    server.listen
  end
end

app = Fort.new
app.routes = [{
  controllerName: "DefaultController",
  path:           "/default",
}]
# app.routes = ["as"]
app.port = 3000
app.create
