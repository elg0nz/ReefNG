module Systems
  class Router
    def initialize
      @routes = {}
    end

    def action(path, &blk)
      @routes[path] = blk
    end

    def route(path)
      handler = @routes[path] || -> { "no route found for #{path}" }
      handler.call
    end
  end
end
