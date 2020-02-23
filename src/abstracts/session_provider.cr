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

      abstract def is_session_exist : Async(Bool)
      abstract def get(key : String) : Async(JSON::Any)
      abstract def get?(key : String) : Async(JSON::Any | Nil)
      abstract def is_exist(key : String) : Async(Bool)
      abstract def get_all : Async(Hash(String, JSON::Any))
      abstract def set(key : String, val : JSON::Any) : Async(Nil)
      abstract def set_many(values : Hash(String, JSON::Any)) : Async(Nil)
      abstract def remove(key : String) : Async(Nil)
      abstract def remove?(key : String) : Async(Nil)

      abstract def clear : Async(Nil)

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
