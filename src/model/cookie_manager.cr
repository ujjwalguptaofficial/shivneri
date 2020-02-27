require "./http_cookie"

module Shivneri
  module MODEL
    class CookieManager
      property response_cookie
      #  cookie_collection
      @response_cookie = [] of String
      @cookie_collection : Hash(String, String)

      def initialize(parsedValue : Hash(String, String))
        @cookie_collection = parsedValue
        # @name = ""
      end

      def initialize
        @cookie_collection = {} of String => String
        # @name = ""
      end

      # return cookie by name
      # @param {string} name
      # @returns HttpCookie
      # @memberof CookieManager
      def get_cookie(name : String) : HttpCookie
        return HttpCookie.new(name, @cookie_collection[name], false, "", Time.utc)
      end

      # add cookie
      #
      # @param {HttpCookie} cookie
      # @memberof CookieManager
      #
      def add_cookie(cookie : HttpCookie)
        @cookie_collection[cookie.name] = cookie.value
        @response_cookie.push(get_cookie_string_from_cookie(cookie))
      end

      #
      # remove cookie
      #
      # @param {HttpCookie} cookie
      # @memberof CookieManager
      #
      def remove_cookie(cookie : HttpCookie)
        @cookie_collection.delete(cookie.name)
        cookie.expires = Time.utc(1900, 1, 1) # Time.new("Thu, 01 Jan 1970 00:00:00 GMT")
        cookie.max_age = -1
        @response_cookie.push(get_cookie_string_from_cookie(cookie))
      end

      #
      # collection of http cookie
      #
      # @readonly
      # @memberof CookieManager
      #
      def cookie_collection
        return @cookie_collection
      end

      #
      # determine whether value exist or not
      #
      # @param {string} name
      # @returns
      # @memberof CookieManager
      #
      def is_exist(name : String)
        return @cookie_collection.has_key?(name)
      end

      private def get_cookie_string_from_cookie(cookie : HttpCookie)
        cookies = ["#{cookie.name}=#{cookie.value}"]
        if (cookie.expires)
          cookies.push("Expires=#{cookie.expires.to_utc.to_s}")
        end
        if (cookie.http_only)
          cookies.push("HttpOnly")
        end
        if (cookie.max_age != nil)
          cookies.push("Max-Age=#{cookie.max_age}")
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
