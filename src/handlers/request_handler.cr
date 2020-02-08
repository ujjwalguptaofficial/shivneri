require "http"
require "../fort_global"
require "./controller_result_handler"
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

    class RequestHandler < ControllerResultHandler
      property request

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
        @response.headers["X-Powered-By"] = FortGlobal.appName
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
        requestMethod = @request.method
        shouldExecuteNextProcess : Bool = self.parse_cookie_from_request
        if (shouldExecuteNextProcess)
          path_url = @request.path
          #  shouldExecuteNextProcess = await this.executeWallIncoming_
          begin
            route_match_info = parseRoute?(path_url.downcase, requestMethod)
            if (route_match_info == nil) # no route matched
              # it may be a file or folder then
              # @handleFileRequest(pathUrl);
            else
              @route_match_info = route_match_info.as(RouteMatch)
              self.on_route_matched
            end
          rescue ex
            self.onErrorOccured(ex)
          end
        end
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
          #     shouldExecuteNextComponent = await this.handlePostData();
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
        result = self.set_controller_props
        # self.on_result_from_controller(result)
      end

      private def on_result_from_controller(result : HttpResult)
      end

      macro run_worker(klass, workerName)
        {% for method in klass.methods.select { |m| m.name == workerName } %}
          {% mName = "#{method.name}" %}
        #return controllerObj
        {% end %}
      end

      private def set_controller_props
        controllerObj : Controller = @route_match_info.controllerInfo.controllerId.new
        controllerObj.request = @request
        controllerObj.response = @response
        # controllerObj.query = this.query_;
        # controllerObj.body = this.body;
        # controllerObj.session = this.session_;
        # controllerObj.cookie = this.cookieManager;
        # controllerObj.param = this.routeMatchInfo_.params;
        # controllerObj.data = this.data_;
        # controllerObj.file = this.file;

        return @route_match_info.workerInfo.as(WorkerInfo).workerProc.call
        # methods = klass.id.{{methods}}
        # run_worker(klass, @route_match_info.workerInfo.workerName)
        # run_worker :klass, @route_match_info.workerInfo.workerName
        # {% for method in GenericController.methods.select { |m| m.name == workerName } %}
        #   {% mName = "#{method.name}" %}
        # #return controllerObj
        # {% end %}
        # return controllerObj[this.routeMatchInfo_.workerInfo.workerName]();
      end

      private def parse_cookie_from_request : Bool
        if (FortGlobal.shouldParseCookie)
          rawCookie = @request.headers[CONSTANTS.cookie] || @request.headers["cookie"]

          begin
            parsedCookies = parse_cookie(rawCookie)
            # @session_ = new FortGlobal.sessionProvider
            # @session_.cookie = @cookieManager = CookieManager.new(parsedCookies)
            # @session_.sessionId = parsedCookies[FortGlobal.appSessionIdentifier]
          rescue ex
            self.onErrorOccured(ex)
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
