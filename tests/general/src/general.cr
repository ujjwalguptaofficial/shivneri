require "../../../src/fort"
require "./controllers/default_controller"
require "./controllers/session_controller"
require "./controllers/home_controller"
require "./controllers/random_controller"
require "./controllers/user_controller"
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
  routes = [{
    controller: DefaultController,
    path:       "/*",
  }, {
    controller: SessionController,
    path:       "/session",
  }, {
    controller: HomeController,
    path:       "/home",
  }, {
    controller: RandomController,
    path:       "/random",
  }, {
    controller: UserController,
    path:       "/user",
  }]
  routes.each do |route|
    app.register_controller(route[:controller], route[:path])
  end
  app.walls = [WallWithoutOutgoing.as(Wall.class)]
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

if (ENV["CRYSTAL_ENV"]? != "TEST")
  init_app
  puts "Your fort is located at address - #{ENV["APP_URL"]}"
  puts "ENV is - #{ENV["CRYSTAL_ENV"]}"
end
