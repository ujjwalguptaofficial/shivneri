module CrystalInsideFort
  class FortGlobal
    @@appName = "fort"
    @@shouldParseCookie = true
    @@walls = [] of Wall.class
  end

  def FortGlobal.appName
    return @@appName
  end

  def FortGlobal.shouldParseCookie
    return @@shouldParseCookie
  end

  def FortGlobal.walls
    return @@walls
  end
end
