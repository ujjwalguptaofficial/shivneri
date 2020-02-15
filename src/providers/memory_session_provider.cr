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

      def get(key : String)
        return Async(JSON::Any).new(->{
          saved_session = session_values[self.session_id]
          return savedSession != nil ? savedSession[key] : nil
        })
      end

      def is_exist(key : String)
        return Async(Bool).new(->{
          saved_value = session_values[self.session_id]
          return saved_value == nil ? false : saved_value[key] != nil
        })
      end

      def get_all
        return Async(JSON::Any).new(->{
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
            # saved_value = session_values[self.session_id]
            #   if (saved_value == nil)
            self.create_session
            @@session_values[self.session_id] = {
              "#{key}" => val,
            }
          end
        })
      end

      def set_many(values)
        return Async(Nil).await_many(values.map { |key, value| self.set(key, value) })
      end

      def remove(key : String)
        if (is_session_created)
          saved_value = session_values[self.session_id]
          if (saved_value.has_key(key))
            saved_value.delete(key)
          end
        end
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
