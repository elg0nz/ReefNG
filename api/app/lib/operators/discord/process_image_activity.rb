require_relative "../../../models/systems"

module Operators
  module Discord
    class ProcessImageActivity < Temporal::Activity
      def execute(data)
        process_image = Systems::Discord::ImageProcessor.new(data)
        process_image.call do |m|
          m.success do |response|
            Temporal.logger.info("ProcessImageActivity result: #{result}")
          end
          m.failure do |error|
            Temporal.logger.error("ProcessImageActivity error: #{error}")
          end
        end

        nil
      end
    end
  end
end
