require "dry-struct"
module Types
  include Dry.Types()
end

class Systems::Discord::InteractionData < Dry::Struct
  attribute :channel_id, Types::String
  attribute :guild_id, Types::String
  attribute :image_url, Types::String
  attribute :message_id, Types::String # TODO: introduce a SnowflakeID type
end
