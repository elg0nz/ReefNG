require "dry-struct"
module Types
  include Dry.Types()
end

class Systems::Discord::InteractionData < Dry::Struct
  attribute :channel_id, Types::String
  attribute :guild_id, Types::String
end
