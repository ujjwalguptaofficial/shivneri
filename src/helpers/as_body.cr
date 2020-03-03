module Shivneri
  module HELPER
    macro get_default_value(data_type)
      case {{data_type}}
      when "String"
        return ""
      end
    end

    def convert_to(value, data_type)
      case data_type
      when "String"
        return value.as_s
      end
    end

    macro as_body(value)
      return -> (body_data : Hash(String, JSON::Any)) {
        # {{value}}.new
        {% begin %}
        {{value}}.new(
            {% for key, data_type in NamedTuple(name: String) %}
                {% key_as_string = key.stringify %}
                {% type_as_string = data_type.stringify %}
                # puts {{key_as_string}} 
                # puts get_default_values({{type_as_string}})
                {{key_as_string}}: (body_data.has_key?({{key_as_string}}? convert_to(body_data[{{key_as_string}}], {{type_as_string}}) : get_default_value({{type_as_string}}))),     
            {% end %}
        )
        {% end %}
        return nil;
      }
    end
  end
end
