require "temporal-ruby"
require_relative "./pong_activity"

class HandleSlashCommandWorkflow < Temporal::Workflow
  def execute(data)
    ## TODO: create discord system, and call it here
    PongActivity.execute!(data)

    nil
  end
end
