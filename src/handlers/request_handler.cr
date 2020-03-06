require "http"
require "../fort_global"
require "./post_handler"
require "../model/index"
require "../constants"
require "../helpers/index"
require "../generics/index"
require "../aliases"

module Shivneri
  module Handlers
    include CONSTANTS
    include HELPER
    include MODEL
    include GENERIC

    class RequestHandler < PostHandler
      getter query, request, route_match_info, response, session_provider, component_data
      @query = {} of String => String
      @component_data = {} of String => JSON::Any
      @request : HTTP::Request
      @response : HTTP::Server::Response

      @route_match_info : RouteMatch | Nil = nil

      @session_provider : SessionProvider | Nil = nil

      def logger
        return FortGlobal.logger
      end

      def worker_name
        return @route_match_info.as(RouteMatch).worker_info.as(WorkerInfo).name
      end

      def route_match_info
        @route_match_info.as(RouteMatch)
      end

      def initialize
        @request = HTTP::Request.new("", "")
        @response = HTTP::Server::Response.new(IO::Memory.new("temp"))
      end

      def initialize(request : HTTP::Request, response : HTTP::Server::Response)
        @request = request
        @response = response
      end

      def handle
        set_pre_header
        execute
      end

      private def set_pre_header
        @response.headers["X-Powered-By"] = FortGlobal.app_name
        @response.headers["Vary"] = "Accept-Encoding"
        @response.headers["Date"] = Time.utc.to_s
      end

      private def execute_wall_incoming
        status = true
        FortGlobal.walls.each do |create_wall_instance|
          wall_instance = create_wall_instance.call(self)
          self.wall_instances.push(wall_instance)
          wall_result = wall_instance.on_incoming.as(HttpResult | Nil)
          if (wall_result != nil)
            status = false
            self.on_termination_from_Wall(wall_result.as(HttpResult))
          end
          break if status == false
        end
        return status
      end

      private def execute
        @request.query_params.each do |name, value|
          @query[name] = value
        end

        shouldExecuteNextProcess : Bool = self.parse_cookie_from_request
        if (shouldExecuteNextProcess)
          url = @request.path
          shouldExecuteNextProcess = execute_wall_incoming
          if (shouldExecuteNextProcess == false)
            return
          end
          requestMethod = @request.method
          begin
            route_match_info = parseRoute?(url.downcase, requestMethod)
            if (route_match_info == nil) # no route matched
              # it may be a file or folder then
              self.handle_file_request(url)
            else
              @route_match_info = route_match_info.as(RouteMatch)
              self.on_route_matched
            end
          rescue ex1 : TupleBodyException
            self.on_bad_request(ex1)
          rescue ex
            self.on_error_occured(ex)
          end
        end
      end

      private def handle_post_data
        if (FortGlobal.should_parse_post == true && @request.method != HTTP_METHOD["get"] && @request.body != nil)
          begin
            self.parse_post_data_and_set_body
          rescue ex
            self.on_bad_request(ex)
            return false
          end
        end
        return true
      end

      private def on_route_matched
        worker_info = route_match_info.worker_info
        if (worker_info == nil)
          if (@request.method == HTTP_METHOD["options"])
            self.on_request_options(route_match_info.allowedHttpMethod)
          else
            self.on_method_not_allowed(route_match_info.allowedHttpMethod)
          end
        else
          should_execute_next_component = self.execute_shields_protection
          if (should_execute_next_component == true)
            should_execute_next_component = self.handle_post_data
            if (should_execute_next_component == true)
              should_execute_next_component = execute_guards_protection
              if (should_execute_next_component)
                self.run_controller
              end
            end
          end
        end
      end

      private def execute_shields_protection
        status = true
        route_match_info.shields.each do |shield_name|
          shield_result = RouteHandler.get_shield_proc(shield_name).call(self).as(HttpResult | Nil)
          if (shield_result != nil)
            status = false
            self.on_result_from_controller(shield_result.as(HttpResult))
          end
          break if status == false
        end
        return status
      end

      private def execute_guards_protection
        status = true
        route_match_info.worker_info.as(WorkerInfo).guards.each do |guard_name|
          guard_result = RouteHandler.get_guard_proc(guard_name).call(self)
          if (guard_result != nil)
            status = false
            self.on_result_from_controller(guard_result.as(HttpResult))
          end
          break if status == false
        end
        return status
      end

      private def run_controller
        self.on_result_from_controller(
          route_match_info.worker_info.as(WorkerInfo).workerProc.call(self)
        )
      end

      private def parse_cookie_from_request : Bool
        if (FortGlobal.should_parse_cookie)
          raw_cookie = ""
          if (@request.headers.has_key?(CONSTANTS.cookie))
            raw_cookie = @request.headers[CONSTANTS.cookie]
          elsif (@request.headers.has_key?("cookie"))
            raw_cookie = @request.headers["cookie"]
          end

          begin
            parsed_cookies = parse_cookie(raw_cookie)
            @cookie_manager = CookieManager.new(parsed_cookies)
            @session_provider = FortGlobal.session_provider.new(@cookie_manager.as(CookieManager))
          rescue ex
            self.on_error_occured(ex)
            return false
          end
        else
          @cookieManager = CookieManager.new({} of String => String)
        end
        return true
      end

      # macro get_tuple_from_body(value)
      #   {{value}}.get_tuple_from_hash_json_any.call(self)
      # end
    end
  end

  def get_default_value(data_type)
    case data_type
    when "String"
      return ""
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
    end
  end

  def convert_to(key : String, value : JSON::Any, data_type)
    begin
      case data_type
      when "String"
        return value.as_s
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
        raise "Invalid data type #{data_type} - json does not support this type."
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
              # name: "ujjwal"
          )
      {% end %}
    }
  end
end
