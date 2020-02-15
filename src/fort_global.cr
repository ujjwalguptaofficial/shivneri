require "./providers/index"

module CrystalInsideFort
  class FortGlobal
    @@app_name = "fort"
    @@should_parse_cookie = true
    @@walls = [] of Proc(RequestHandler, Wall)
    @@error_handler = ErrorHandler
    @@should_parse_post = true
    @@session_timeout : Int32 = 60

    @@session_provider : SessionProvider.class = PROVIDER::MemorySessionProvider.as(SessionProvider.class)
  end

  def FortGlobal.app_name
    return @@app_name
  end

  def FortGlobal.should_parse_cookie
    return @@should_parse_cookie
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

  def FortGlobal.app_session_identifier
    return "#{@@app_name}_session_id"
  end

  def FortGlobal.session_timeout
    return @@session_timeout
  end

  def FortGlobal.session_provider
    return @@session_provider
  end
end
