require "../../../src/fort"
require "./controllers/default_controller"
include CrystalInsideFort
include General
VERSION = "0.1.0"
require "./walls/wall_without_outgoing"

# TODO: Put your code here

class App < Fort
  def intialize
  end
end

app = App.new
app.routes = [{
  controllerName: "DefaultController",
  path:           "/default",
}]
# app.walls = [WallWithoutOutgoing]
app.create
