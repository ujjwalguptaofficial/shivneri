require "../../../src/fort"
require "./controllers/default_controller"
include CrystalInsideFort
include General
VERSION = "0.1.0"

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
app.create
