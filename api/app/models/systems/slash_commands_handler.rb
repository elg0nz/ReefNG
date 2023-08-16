require_relative "./router"

module Systems
  class SlashCommandsHandler
    attr_reader :router

    def initialize
      @router = Router.new
    end

    def handle(event)
      @router.route(event)
    end
  end
end
