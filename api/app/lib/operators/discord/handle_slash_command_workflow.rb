require "temporal-ruby"
require_relative "./pong_activity"
require_relative "./../../../models/systems"
require "json"

module Operators
  module Discord
    class HandleSlashCommandWorkflow < Temporal::Workflow
      # NOTE: this is required to ensure the type matches the one registered
      def workflow_type
        {name: "HandleSlashCommandWorkflow"}
      end

      APPLICATION_COMMAND = 2
      def get_route(data)
        data["data"]["name"]
      end

      def execute(data)
        # Only respond to slash commands
        return unless data["type"] == APPLICATION_COMMAND

        router = Systems::Router.new
        router.action("ping") { PongActivity.execute!(data) }
        router.action("process") do
          # image = GetLastImageInChannel.execute!(data)
          # return unless image
          ProcessImageActivity.execute!(data) ## FIXME: rename to SendDataFromImageActivity
        end

        route = get_route(data)
        router.route(route)
      end
    end
  end
end
