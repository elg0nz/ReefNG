require "test_helper"
require "dry/monads/result"
require "faraday"

class ImageProcessorTest < ActiveSupport::TestCase
  test "process image" do
    interaction_data = Systems::Discord::InteractionData.new(channel_id: "123", guild_id: "456", image_url: "http://placekitten.com/200/300", message_id: "789")
    process_image = Systems::Discord::ImageProcessor.new

    VCR.use_cassette("image_processing") do
      response = process_image.with_step_args(
        build_response: [interaction_data: interaction_data]
      ).call(interaction_data)
      assert_instance_of(Dry::Monads::Result::Success, response)
      response_object = response.value!
      assert(response_object.tags.include?("catnip"))
      assert(response_object.tags.include?("kibble"))
    end
  end
end
