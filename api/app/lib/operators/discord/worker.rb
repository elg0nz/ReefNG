module Operators
  module Discord
    class Worker
      attr_reader :worker

      def initialize
        worker = Temporal::Worker.new(binary_checksum: `git show HEAD -s --format=%H`.strip)
        # Note: It's important to register dyanmically to ensure the WorkflowType is correctly registered
        worker.register_dynamic_workflow(HandleSlashCommandWorkflow, name: "HandleSlashCommandWorkflow")
        worker.register_activity(PongActivity)
        worker.register_activity(ProcessImageActivity)
        worker.start

        @worker = worker
      end
    end
  end
end
