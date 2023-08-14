require "test_helper"

require "securerandom"

class UserTest < ActiveSupport::TestCase
  test "fixture users are available" do
    assert_equal 2, Components::User.count
    first_user = Components::User.find(components_users(:user_one).id)
    assert_equal "one-breeze-9298", first_user.friendly_name
    second_user = Components::User.find(components_users(:user_two).id)
    assert_equal "two-resonance-4789", second_user.friendly_name
  end

  test "validations" do
    new_user = Components::User.new
    assert_not new_user.valid?

    new_user.id = SecureRandom.uuid
    assert_not new_user.valid?

    friendly_name = "blah"
    new_user.friendly_name = friendly_name
    assert new_user.valid?
    new_user.save
    assert_equal 3, Components::User.count
  end
end
