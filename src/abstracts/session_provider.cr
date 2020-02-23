require "uuid"

module CrystalInsideFort
  module ABSTRACT
    abstract class SessionProvider
      getter session_id
      session_id : String
      cookie : CookieManager

      def initialize(@cookie : CookieManager)
        if (@cookie.is_exist(FortGlobal.app_session_identifier))
          @session_id = @cookie.cookie_collection[FortGlobal.app_session_identifier]
        else
          @session_id = ""
        end
      end

      protected def cookie
        return @cookie
      end

      abstract def is_session_exist : Bool
      abstract def [](key : String) : JSON::Any
      abstract def is_exist(key : String) : Bool
      abstract def get_all : Hash(String, JSON::Any)
      abstract def []=(key : String, val : JSON::Any) : Nil
      abstract def set_many(values : Hash(String, JSON::Any)) : Nil
      abstract def remove(key : String) : Nil
      abstract def remove?(key : String) : Nil

      abstract def clear : Nil

      def is_session_created
        session_id != nil
      end

      protected def create_session
        # create_session_from_id(SecureRandom.uuid)
        create_session_from_id(UUID.random.to_s)
      end

      protected def create_session(session_id)
        create_session_from_id(session_id)
      end

      private def create_session_from_id(session_id)
        now = Time.utc
        @session_id = session_id
        cookie = HttpCookie.new(FortGlobal.app_session_identifier, session_id, true, "/", now + FortGlobal.session_timeout.minutes)
        @cookie.add_cookie(cookie)
      end

      protected def destroy_session
        cookie = self.cookie.get_cookie(FortGlobal.app_session_identifier)
        cookie.http_only = true
        cookie.path = "/"
        self.cookie.remove_cookie(cookie)
      end
    end
  end
end
