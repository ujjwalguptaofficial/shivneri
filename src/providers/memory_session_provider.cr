require "../abstracts/session_provider"

module CrystalInsideFort
  module PROVIDER
    class MemorySessionProvider < ABSTRACT::SessionProvider
      # def initialize(cookie)
      #   super(cookie)
      # end

      @@session_values = {} of String => Hash(String, JSON::Any)

      def is_session_exist : Bool
        return is_session_created && @@session_values.has_key?(@session_id)
      end

      def get?(key : String)
        return Async(JSON::Any | Nil).new(->{
          if (is_exist(key))
            return @@session_values[self.session_id][key]
          end
          return nil
        })
      end

      def get(key : String)
        return Async(JSON::Any).new(->{
          return @@session_values[self.session_id][key]
        })
      end

      def is_exist(key : String)
        return Async(Bool).new(->{
          return is_session_created && @@session_values[self.session_id].has_key?(key)
        })
      end

      def get_all
        return Async(Hash(String, JSON::Any)).new(->{
          if (is_session_exist)
            return @@session_values[self.session_id]
          end
          return {} of String => JSON::Any
        })
      end

      def set(key : String, val)
        return Async(Nil).new(->{
          if (is_session_exist)
            @@session_values[self.session_id][key] = val
          else
            self.create_session
            @@session_values[self.session_id] = {
              "#{key}" => val,
            }
          end
          return nil
        })
      end

      def set(key : JSON::Any, val)
        return self.set(key.to_s, val)
      end

      def set_many(values)
        return Async(Nil).await_many(values.map { |key, value| self.set(key, value) })
      end

      def remove?(key : String)
        return Async(Nil).new(->{
          if (is_exist(key))
            
          end
        })
      end

      def clear
        #    remove session values
        session_values[self.session_id].clear
        # expire cookie in browser
        self.destroy_session.await
      end
    end
  end
end
