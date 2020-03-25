module Shivneri
  module HELPER
    def get_default_value(data_type)
      case data_type
      when "String"
        return ""
      when "Int"
      when "Int32"
        return 0
      when "Int64"
        return 0.to_i64
      when "Float32"
        return 0.to_f32
      when "Float64"
        return 0.to_f
      when "Char"
        return ' '
      when "Int8"
        return 0.to_i8
      when "UInt8"
        return 0.to_u8
      when "Int16"
        return 0.to_i16
      when "UInt16"
        return 0.to_u16
      when "UInt32"
        return 0.to_u32
      when "UInt64"
        return 0.to_u64
      when "Bool"
        return false
      else
        raise "Invalid data type #{data_type} - json does not support this type."
      end
    end

    def convert_to(key : String, value : JSON::Any, data_type)
      begin
        case data_type
        when "String"
          return value.as_s
        when "Int"
        when "Int32"
          return value.as_i
        when "Int64"
          return value.as_i64
        when "Float32"
          return value.as_f32
        when "Float64"
          return value.as_f
        when "Char"
          return value.as_s[0]
        when "Int8"
          return value.as_i.to_i8
        when "UInt8"
          return value.as_i.to_u8
        when "Int16"
          return value.as_i.to_i16
        when "UInt16"
          return value.as_i.to_u16
        when "UInt32"
          return value.as_i.to_u32
        when "UInt64"
          return value.as_i64.to_u64
        when "Bool"
          return value.as_bool
        else
          raise "Invalid data type #{data_type} for property '#{key}' - json does not support this type."
        end
      rescue TypeCastError
        raise TupleBodyException.new(
          "Invalid value supplied for property - '#{key}', should be type of #{data_type}"
        )
      end
    end

    def convert_to(key : String, value : String, data_type)
      begin
        case data_type
        when "String"
          return value
        when "Int"
        when "Int32"
          return value.to_i
        when "Int64"
          return value.to_i64
        when "Float32"
          return value.to_f32
        when "Float64"
          return value.to_f64
          # when "Char"
          #   return value[0].to_s
        when "Int8"
          return value.to_i8
        when "UInt8"
          return value.to_u8
        when "Int16"
          return value.to_i16
        when "UInt16"
          return value.to_u16
        when "UInt32"
          return value.to_u32
        when "UInt64"
          return value.to_u64
        when "Bool"
          return value == "true"
        else
          raise "Invalid data type #{data_type} for property '#{key}' - json does not support this type."
        end
      rescue TypeCastError
        raise TupleBodyException.new(
          "Invalid value supplied for property - '#{key}', should be type of #{data_type}"
        )
      end
    end

    def NamedTuple.get_tuple_from_hash_json_any
      return ->(body_data : Hash(String, JSON::Any)) {
        {% begin %}
                  return NamedTuple.new(
                        {% for key, data_type in T %}
                            {% key_as_string = key.stringify %}
                            {% type_as_string = data_type.stringify %}
                            {{key_as_string}}: (body_data.has_key?({{key_as_string}})? 
                              convert_to({{key_as_string}}, body_data[{{key_as_string}}], {{type_as_string}}) : 
                              get_default_value({{type_as_string}})).as({{data_type}}),     
                        {% end %}
                    )
                {% end %}
      }
    end

    def NamedTuple.get_tuple_from_hash_string
      return ->(body_data : Hash(String, String)) {
        {% begin %}
                  return NamedTuple.new(
                        {% for key, data_type in T %}
                            {% key_as_string = key.stringify %}
                            {% type_as_string = data_type.stringify %}
                            {{key_as_string}}: (body_data.has_key?({{key_as_string}})? 
                              convert_to({{key_as_string}}, body_data[{{key_as_string}}], {{type_as_string}}) : 
                              get_default_value({{type_as_string}})).as({{data_type}}),     
                        {% end %}
                        # name: "ujjwal"
                    )
                {% end %}
      }
    end
  end
end
