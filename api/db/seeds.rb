require "SecureRandom"
Components::User.create!(id: SecureRandom.uuid, friendly_name: "user-one")
