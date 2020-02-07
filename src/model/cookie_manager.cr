require "./http_cookie"

module CrystalInsideFort
  module MODEL
    class CookieManager
      # property response_cookie, cookie_collection
      @response_cookie = [] of String
      @cookie_collection : Hash(String, String)

      def initialize(parsedValue : Hash(String, String))
        @cookie_collection = parsedValue
        @name = ""
      end

      # return cookie by name
      # @param {string} name
      # @returns HttpCookie
      # @memberof CookieManager
      def get_cookie(name : String) : HttpCookie
        return HttpCookie.new(name, @cookie_collection[name])
      end

      # add cookie
      #
      # @param {HttpCookie} cookie
      # @memberof CookieManager
      #
      def addCookie(cookie : HttpCookie)
        @cookie_collection[cookie.name] = cookie.value
        @response_cookie.push(this.getCookieStringFromCookie_(cookie))
      end

      #
      # remove cookie
      #
      # @param {HttpCookie} cookie
      # @memberof CookieManager
      #
      def removeCookie(cookie : HttpCookie)
        @cookie_collection[cookie.name] = null
        @cookie.expires = Time.new("Thu, 01 Jan 1970 00:00:00 GMT")
        @cookie.maxAge = -1
        @response_cookie.push(this.getCookieStringFromCookie_(cookie))
      end

      #
      # collection of http cookie
      #
      # @readonly
      # @memberof CookieManager
      #
      def cookieCollection
        return @cookie_collection
      end

      #
      # determine whether value exist or not
      #
      # @param {string} name
      # @returns
      # @memberof CookieManager
      #
      def isExist(name : String)
        return @cookie_collection[name] != nil
      end

      private def get_cookie_string_from_cookie(cookie : HttpCookie)
        cookies = ["#{cookie.name}=#{cookie.value}"]
        if (cookie.expires)
          cookies.push("Expires=#{cookie.expires.utc.to_s}")
        end
        if (cookie.httpOnly)
          cookies.push("HttpOnly")
        end
        if (cookie.maxAge != nil)
          cookies.push("Max-Age=#{cookie.maxAge}")
        end
        if (cookie.path)
          cookies.push("Path=#{cookie.path}")
        end
        if (cookie.domain)
          cookies.push("Domain=#{cookie.domain}")
        end
        return cookies.join("; ")
      end
    end
  end
end
