require "temporal/worker"
require_relative "../../app/lib/operators/discord/handle_slash_command_workflow"
require_relative "../../app/lib/operators/discord/pong_activity"

namespace :operators do
  desc "respond to discord tasks"
  task discord: [:environment] do
    worker = Temporal::Worker.new(binary_checksum: `git show HEAD -s --format=%H`.strip)
    worker.register_workflow(HandleSlashCommandWorkflow)
    worker.register_activity(PongActivity)
    worker.start
  end
end
