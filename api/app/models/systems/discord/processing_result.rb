require "dry-struct"
module Types
  include Dry.Types()
end

class Systems::Discord::ProcessingResult < Dry::Struct
  attribute :channel_id, Types::String
  attribute :guild_id, Types::String
  attribute :message_id, Types::String # TODO: introduce a SnowflakeID type
  attribute :content, Types::String
  attribute :title, Types::String
  attribute :image, Types::String
  attribute :tags, Types::Array.of(Types::String)
end
