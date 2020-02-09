require "http"
require "../fort_global"
require "./post_handler"
require "../model/index"
require "../constants"
require "../helpers/index"
require "../generics/index"

module CrystalInsideFort
  module Handlers
    include CONSTANTS
    include HELPER
    include MODEL
    include GENERIC

    class RequestHandler < PostHandler
      getter query, request, route_match_info

      @query = {} of String => String | Int32

      @request : HTTP::Request
      @response : HTTP::Server::Response
      @wallInstances : Array(Wall) = [] of Wall

      @route_match_info : RouteMatch = RouteMatch.new(RouteInfo.new(GenericController))

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

      private def executeWallIncoming_ : Boolean
        index = 0
        wallLength = FortGlobal.walls.length
        executeWallIncomingByIndex = ->(wall) {
          if (wallLength > index)
            wall = FortGlobal.walls[index += 1]
            constructorArgsValues = InjectorHandler.getConstructorValues(wall.name)
            wallObj = wall.new(...constructorArgsValues)
            wallObj.cookie = this.cookieManager
            wallObj.session = this.session_
            wallObj.request = this.request as HttpRequest
            wallObj.response = this.response as HttpResponse
            wallObj.data = this.data_
            wallObj.query = this.query_
            @wallInstances.push(wallObj)

            begin
              const result = await wallObj.onIncoming
              if (result == null)
                executeWallIncomingByIndex()
              else
                return false
                self.onTerminationFromWall(result)
              end
            rescue ex
              self.onErrorOccured(ex)
              return false
            end
          else
            return true
          end
        }
        executeWallIncomingByIndex()
      end

      private def execute
        @request.query_params.each do |name, value|
          @query[name] = value
        end

        shouldExecuteNextProcess : Bool = self.parse_cookie_from_request
        if (shouldExecuteNextProcess)
          path_url = @request.path
          puts "url is #{path_url}"
          #  shouldExecuteNextProcess = await this.executeWallIncoming_
          requestMethod = @request.method
          begin
            route_match_info = parseRoute?(path_url.downcase, requestMethod)
            if (route_match_info == nil) # no route matched
              # it may be a file or folder then
              # @handleFileRequest(pathUrl);
              puts "url not matched"
            else
              puts "url matched"
              @route_match_info = route_match_info.as(RouteMatch)
              self.on_route_matched
            end
          rescue ex
            puts "exception #{ex.message} #{ex.callstack.as(CallStack).printable_backtrace}"
            self.onErrorOccured(ex)
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
        actionInfo = @route_match_info.workerInfo
        if (actionInfo == nil)
          if (@request.method == HTTP_METHOD["options"])
            # this.onRequestOptions(this.routeMatchInfo_.allowedHttpMethod);
          else
            # this.onMethodNotAllowed(this.routeMatchInfo_.allowedHttpMethod);
          end
        else
          # let shouldExecuteNextComponent = await this.executeShieldsProtection_();
          # if (shouldExecuteNextComponent === true)
          shouldExecuteNextComponent = self.handle_post_data
          #     if (shouldExecuteNextComponent === true) {
          #         this.checkExpectedBody_();

          # shouldExecuteNextComponent = await this.executeGuardsCheck_(actionInfo.guards);
          # if (shouldExecuteNextComponent)
          self.run_controller
          # end
          # }
          # end
        end
      end

      private def run_controller
        puts "hitting controller"
        # controllerObj : Controller = @route_match_info.controllerInfo.controllerId.new
        # controllerObj.request = @request
        # controllerObj.response = @response
        # controllerObj.query = this.query_;
        # controllerObj.body = this.body;
        # controllerObj.session = this.session_;
        # controllerObj.cookie = this.cookieManager;
        # controllerObj.param = this.routeMatchInfo_.params;
        # controllerObj.data = this.data_;
        # controllerObj.file = this.file;

        result = @route_match_info.workerInfo.as(WorkerInfo).workerProc.call(self)
        self.on_result_from_controller(result)
      end

      private def parse_cookie_from_request : Bool
        # if (FortGlobal.shouldParseCookie)
        #   rawCookie = @request.headers[CONSTANTS.cookie] || @request.headers["cookie"]

        #   begin
        #     parsedCookies = parse_cookie(rawCookie)
        #     # @session_ = new FortGlobal.sessionProvider
        #     # @session_.cookie = @cookieManager = CookieManager.new(parsedCookies)
        #     # @session_.sessionId = parsedCookies[FortGlobal.appSessionIdentifier]
        #   rescue ex
        #     self.onErrorOccured(ex)
        #     return false
        #   end
        # else
        #   @cookieManager = CookieManager.new({} of String => String)
        # end
        return true
      end
    end
  end
end
