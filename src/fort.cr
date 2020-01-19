require "./abstracts/index"
require "http/server"

module CrystalInsideFort
  class Fort
    # @server = nil;
    setter port : Int32 = 4000
    setter routes = [] of NamedTuple(controllerName: String, path: String)

    def initialize
      @server = HTTP::Server.new do |context|
        context.response.content_type = "text/plain"
        context.response.print "Hello world! The time is #{Time.local}"
      end
    end

    def create
      # puts Controller.name;
      # Controller.all_subclasses.each do |controller|
      #   puts "controller name: #{controller.name}"
      # end

      @routes.each do |route|
        puts "route controller name #{route[:controllerName]}"
      end
      puts "routes length"
      address = @server.bind_tcp @port
      puts "Your fort is available on http://#{address}"
      @server.listen
    end

    def finalize
      @server.close
    end
  end
end

# app = Fort.new
# app.routes = [{
#   controllerName: "DefaultController",
#   path:           "/default",
# }]
# # app.routes = ["as"]
# app.port = 3000
# app.create
