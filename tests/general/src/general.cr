require "../../../src/fort"
require "./controllers/default_controller"
require "./controllers/session_controller"
require "./controllers/home_controller"
require "./controllers/random_controller"
include CrystalInsideFort
include General
VERSION = "0.1.0"
require "./walls/wall_without_outgoing"

# TODO: Put your code here

class App < Fort
  def intialize
  end
end

def init_app
  app = App.new
  app.routes = [{
    controller_name: "DefaultController",
    path:            "/default",
  }, {
    controller_name: "SessionController",
    path:            "/session",
  }, {
    controller_name: "HomeController",
    path:            "/home",
  }, {
    controller_name: "RandomController",
    path:            "/random",
  }]
  # app.walls = [WallWithoutOutgoing]
  app_option = AppOption.new
  app_option.folders = [{
    path_alias: "static",
    path:       File.join(Dir.current, "static"),
  }]
  app.create(app_option)
  puts "app started"
  ENV["APP_URL"] = "http://localhost:#{app.port}"
  # puts "curent dir #{Dir.current}"
  return app
end

puts "ENV is - #{ENV["CRYSTAL_ENV"]}"
if (ENV["CRYSTAL_ENV"]? != "TEST")
  init_app
  puts "Your fort is located at address - #{ENV["APP_URL"]}"
  puts "ENV is - #{ENV["CRYSTAL_ENV"]}"
end
