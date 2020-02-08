module CrystalInsideFort
  class FortGlobal
    @@app_name = "fort"
    @@shouldParseCookie = true
    @@walls = [] of Wall.class
    @@error_handler = ErrorHandler
    @@should_parse_post = true
  end

  def FortGlobal.app_name
    return @@app_name
  end

  def FortGlobal.shouldParseCookie
    return @@shouldParseCookie
  end

  def FortGlobal.walls
    return @@walls
  end

  def FortGlobal.error_handler
    return @@error_handler
  end

  def FortGlobal.should_parse_post
    return @@should_parse_post
  end
end
