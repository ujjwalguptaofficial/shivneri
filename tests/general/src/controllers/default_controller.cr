require "../../../../src/fort"

module General
  include CrystalInsideFort

  class DefaultController < Controller
    def say
      puts "hey Ujjwal"
    end
  end
end
