require "http"
require "../fort_global"
require "./post_handler"
require "../model/index"
require "../constants"
require "../helpers/index"
require "../generics/index"
require "../aliases"

module CrystalInsideFort
  module Handlers
    include CONSTANTS
    include HELPER
    include MODEL
    include GENERIC

    class RequestHandler < PostHandler
      getter query, request, route_match_info, response, result_channel, session_provider, component_data

      @result_channel = Channel(HttpResult | Nil).new

      @component_channel = Channel(Bool).new

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

      def initialize(request : HTTP::Request, response : HTTP::Server::Response)
        @request = request
        @response = response
        # @route_match_info = RouteMatch.new
      end

      def handle
        setPreHeader
        execute
      end

      private def setPreHeader
        @response.headers["X-Powered-By"] = FortGlobal.app_name
        @response.headers["Vary"] = "Accept-Encoding"
        @response.headers["Date"] = Time.utc.to_s
      end

      private def execute_wall_incoming
        return Async(Bool).new(->{
          status = true
          FortGlobal.walls.each do |create_wall_instance|
            wall_instance = create_wall_instance.call(self)
            self.wall_instances.push(wall_instance)
            puts "executing wall"
            wall_result = Async(HttpResult | Nil).new(->{
              return wall_instance.on_incoming.as(HttpResult | Nil)
            }).await
            # puts "receiving wall"
            puts "received wall"
            if (wall_result != nil)
              status = false
              self.on_termination_from_Wall(wall_result.as(HttpResult))
            end
            break if status == false
          end
          puts "wall status #{status}"
          return status
          # @component_channel.send(status)
        })
      end

      private def execute
        @request.query_params.each do |name, value|
          @query[name] = value
        end

        shouldExecuteNextProcess : Bool = self.parse_cookie_from_request
        if (shouldExecuteNextProcess)
          path_url = @request.path
          puts "url is #{path_url}"

          shouldExecuteNextProcess = execute_wall_incoming.yield_await
          #  @component_channel.receive
          puts "shouldExecuteNextProcess from wall #{shouldExecuteNextProcess}"
          if (shouldExecuteNextProcess == false)
            return
          end
          requestMethod = @request.method
          begin
            route_match_info = parseRoute?(path_url.downcase, requestMethod)
            if (route_match_info == nil) # no route matched
              # it may be a file or folder then
              self.handle_file_request(path_url)
              puts "url not matched"
            else
              puts "url matched"
              @route_match_info = route_match_info.as(RouteMatch)
              self.on_route_matched
            end
          rescue ex
            puts "exception #{ex.message} #{ex.callstack.as(CallStack).printable_backtrace}"
            self.on_error_occured(ex)
          end
        end
      end

      private def handle_post_data
        if (@request.method == HTTP_METHOD["get"])
          puts "me"
          # this.file = new FileManager({});
        elsif (@request.body != nil && FortGlobal.should_parse_post == true)
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
          # self.execute_shields_protection
          should_execute_next_component = self.execute_shields_protection.yield_await
          # @component_channel.receive
          if (should_execute_next_component == true)
            should_execute_next_component = self.handle_post_data
            if (should_execute_next_component == true)
              #         this.checkExpectedBody_();
              should_execute_next_component = execute_guards_protection.yield_await
              # should_execute_next_component = @component_channel.receive
              if (should_execute_next_component)
                self.run_controller
              end
            end
          end
        end
      end

      private def execute_shields_protection
        # spawn do
        return Async(Bool).new(->{
          puts "hitting shield #{route_match_info.shields.size}"
          status = true

          route_match_info.shields.each do |shield_name|
            puts "executin shield"
            shield_result = Async(ALIAS::ComponentResult).new(->{
              puts "shield name #{shield_name}"
              shield_results = RouteHandler.get_shield_proc(shield_name).call(self).as(HttpResult | Nil)
              # puts shield_results != nil
              # puts "type is #{typeof(shield_results)}"
              return shield_results
            }).await
            puts "shield_result #{shield_result.to_json}"
            if (shield_result != nil)
              status = false
              self.on_result_from_controller(shield_result.as(HttpResult))
            end
            break if status == false
          end
          puts "status from shield #{status}"
          return status
        })
        # end
      end

      private def execute_guards_protection
        # spawn do
        return Async(Bool).new(->{
          puts "hitting guard #{route_match_info.worker_info.as(WorkerInfo).guards.size}"
          status = true
          route_match_info.worker_info.as(WorkerInfo).guards.each do |guard_name|
            guard_result = Async(ALIAS::ComponentResult).new(->{
              RouteHandler.get_guard_proc(guard_name).call(self)
            }).await

            puts "guard_result #{guard_result}"
            if (guard_result != nil)
              status = false
              self.on_result_from_controller(guard_result.as(HttpResult))
            end
            break if status == false
          end
          puts "status from guard #{status}"
          # @component_channel.send(status)
          return status
          # end
        })
      end

      private def run_controller
        puts "hitting controller"
        self.on_result_from_controller(
          route_match_info.worker_info.as(WorkerInfo).workerProc.call(self)
        )
        # end
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
            # @session_provider.session_id = parsed_cookies
            # @session_.cookie = @cookieManager = CookieManager.new(parsedCookies)
            # @session_.sessionId = parsedCookies[FortGlobal.appSessionIdentifier]
          rescue ex
            self.on_error_occured(ex)
            return false
          end
        else
          @cookieManager = CookieManager.new({} of String => String)
        end
        return true
      end
    end
  end
end
