module Shivneri
  module HELPER
    macro get_default_value(data_type)
      case {{data_type}}
      when "String"
        return ""
      end
      return ""
    end

    def convert_to(value : JSON::Any, data_type)
      case data_type
      when "String"
        return value.as_s
      end
      return ""
    end

    def NamedTuple.map_body
      return ->(body_data : Hash(String, JSON::Any)) {
        {% begin %}
          return  NamedTuple.new(
                {% for key, data_type in T %}
                    {% key_as_string = key.stringify %}
                    {% type_as_string = data_type.stringify %}
                    {{key_as_string}}: body_data.has_key?({{key_as_string}})? convert_to(body_data[{{key_as_string}}], {{type_as_string}}) : get_default_value({{type_as_string}}),     
                {% end %}
            )
        {% end %}
      }
    end

    macro as_body(value)
        {{value}}.map_body
    end
  end
end
