require "test_helper"
require "dry/monads/result"

class ImageProcessorTest < ActiveSupport::TestCase
  test "process image" do
    json_body = file_fixture("slash_interaction.json").read

    process_image = Systems::Discord::ImageProcessor.new
    response = process_image.call(json_body)

    assert_instance_of(Dry::Monads::Result::Success, response)
    ## FIXME: instead of sending an embed, let's send a struct with the required data, and let Go build the embed
    ##       on a second version we will generate the embed from rails, but for now, that's out of scope
    assert_equal("fhwdgads", response.value![:content])
  end
end
