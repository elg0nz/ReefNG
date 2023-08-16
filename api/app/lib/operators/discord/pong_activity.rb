require "temporal-ruby"
require "securerandom"
require "json"

module Operators
  module Discord
    class PongActivity < Temporal::Activity
      def execute(data)
        workflow_id = "discord_pong_#{SecureRandom.uuid}"
        options = {
          workflow_id: workflow_id
        }
        Temporal.start_workflow("PongWorkflow", JSON.generate(data), options: options, task_queue: "discord_tasks")
        nil
      end
    end
  end
end
