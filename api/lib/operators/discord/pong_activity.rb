require "temporal-ruby"
require "securerandom"
require "json"

class PongActivity < Temporal::Activity
  def execute(data)
    workflow_id = "discord_pong_#{SecureRandom.uuid}"
    Temporal.start_workflow("PongWorkflow", JSON.generate(data), {task_queue: "discord_tasks", workflow_id: workflow_id})
    nil
  end
end
