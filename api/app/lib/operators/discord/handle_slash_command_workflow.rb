require "temporal-ruby"
require_relative "./pong_activity"
require_relative "./../../../models/systems"
require "json"

class HandleSlashCommandWorkflow < Temporal::Workflow
  APPLICATION_COMMAND = 2

  def get_route(data)
    data["data"]["name"]
  end

  def execute(data)
    # Only respond to slash commands
    return unless data["type"] == APPLICATION_COMMAND

    router = Systems::Router.new
    router.action("ping") { PongActivity.execute!(data) }

    route = get_route(data)
    router.route(route)
  end
end
