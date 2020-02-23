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
    @@view_engine : ViewEngine = PROVIDER::CrinjaViewEngine.new
    @@view_path = "src/views"
    @@is_env_production : Bool = ENV.has_key?("CRYSTAL_ENV") ? ENV["CRYSTAL_ENV"] == "production" : false # FortGlobal.is_env_production
    @@folders = [] of ALIAS::FolderMap
    @@logger = FortLogger.new
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

  def FortGlobal.view_engine
    @@view_engine
  end

  def FortGlobal.view_path
    @@view_path
  end

  def FortGlobal.is_production
    return @@is_production
  end

  def FortGlobal.folders
    return @@folders
  end

  def FortGlobal.folders=(folders)
    @@folders = folders
  end

  def FortGlobal.logger
    return @@logger
  end
end
