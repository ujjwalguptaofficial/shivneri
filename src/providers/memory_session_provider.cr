require "../abstracts/session_provider"

module Shivneri
  module PROVIDER
    class MemorySessionProvider < ABSTRACT::SessionProvider
      # def initialize(cookie)
      #   super(cookie)
      # end

      @@session_values = {} of String => Hash(String, JSON::Any)

      def is_session_exist : Bool
        return is_session_created && @@session_values.has_key?(self.session_id)
      end

      def []?(key : String) : JSON::Any | Nil
        if (is_exist(key))
          return @@session_values[self.session_id][key]
        end
        return nil
      end

      def [](key : String) : JSON::Any
        return @@session_values[self.session_id][key]
      end

      def is_exist(key : String) : Bool
        return is_session_exist && @@session_values[self.session_id].has_key?(key)
      end

      def get_all : Hash(String, JSON::Any)
        if (is_session_exist)
          return @@session_values[self.session_id]
        end
        return {} of String => JSON::Any
      end

      def []=(key : String, val) : Nil
        if (is_session_exist)
          @@session_values[self.session_id][key] = val
        else
          self.create_session
          @@session_values[self.session_id] = {
            "#{key}" => val,
          }
        end
        return nil
      end

      def []=(key : JSON::Any, val) : Nil
        return self[key.to_s] = val
      end

      def []=(key : String, value : String | Int64 | Nil) : Nil
        return self[key] = JSON::Any.new(value)
      end

      def []=(key : String, value : Int32) : Nil
        return self[key] = value.to_i64
      end

      def set_many(values) : Nil
        values.map { |key, value| self[key] = value }
        return nil
      end

      def remove?(key : String) : Nil
        if (is_exist(key))
          @@session_values[self.session_id].delete(key)
        end
        return nil
      end

      def remove(key : String) : Nil
        @@session_values[self.session_id].delete(key)
        return nil
      end

      def clear? : Nil
        if (is_session_exist)
          self.clear
        end
        return nil
      end

      def clear : Nil
        #    remove session values
        if (is_session_created)
          @@session_values[self.session_id].clear
          # expire cookie in browser
          self.destroy_session
        end
        return nil
      end
    end
  end
end
