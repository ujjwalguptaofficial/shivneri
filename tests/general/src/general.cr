require "../../../src/shivneri"
require "./controllers/default_controller"
require "./controllers/session_controller"
require "./controllers/home_controller"
require "./controllers/random_controller"
require "./controllers/user_controller"
require "./controllers/file_controller"
require "./controllers/cookie_controller"
# require "./controllers/chat_controller"
require "./walls/all"

include Shivneri
include General
VERSION = "0.1.0"

def init_app(on_success = nil)
  # app = App.new
  Shivneri.routes = [{
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
  },
  {
    controller: FileController,
    path:       "/file",
  }, {
    controller: CookieController,
    path:       "/cookie",
  },
  # {
  #   controller: ChatController,
  #   path:       "/chat",
  # },
  ]
  # routes.each do |route|
  #   app.register_controller(route[:controller], route[:path])
  # end
  # Shivneri.routes = routes
  Shivneri.walls = [WallWithoutOutgoing, RequestLogger]
  app_option = AppOption.new
  path_of_static_folder = File.join(Dir.current, "static")
  app_option.folders = [{
    path_alias: "static",
    path:       path_of_static_folder,
  }, {
    path_alias: "/",
    path:       path_of_static_folder,
  }]
  ENV["APP_URL"] = "http://localhost:#{Shivneri.port}"
  Shivneri.open(app_option, on_success)
  return Shivneri
end

if (ENV["CRYSTAL_ENV"]? != "TEST")
  init_app(->{
    puts "Your fort is located at address - #{ENV["APP_URL"]}"
    puts "ENV is - #{ENV["CRYSTAL_ENV"]}"
  })
end
