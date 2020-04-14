require "../../../src/shivneri"
require "./routes"
include Server

module Server
  VERSION = "0.1.0"
  Shivneri.port = 3000
  Shivneri.host = "0.0.0.0"

  def init_app
    return init_app(->{
    })
  end

  def init_app(on_success : Proc(Nil))
    ENV["APP_URL"] = "http://localhost:#{Shivneri.port}"
    Shivneri.open do
      if (on_success != nil)
        on_success.call
      end
    end
    return Shivneri
  end

  if (ENV["CRYSTAL_ENV"]? != "TEST" && ENV["CLOSE_PROCESS"]? != "true")
    init_app(->{
      puts "Your fort is located at address - #{ENV["APP_URL"]}"
      puts "ENV is - #{ENV["CRYSTAL_ENV"]}"
    })
  end
end
