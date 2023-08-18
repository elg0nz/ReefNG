require "discordrb"
require "dry/transaction"

module Systems
  module Discord
    class ImageProcessor
      include Dry::Transaction

      step :validate_json
      step :get_interaction
      step :build_response

      private

      def validate_json(input)
        begin
          body = JSON.parse(input)
        rescue JSON::ParserError => e
          return Failure("Invalid JSON: #{e}")
        end

        return Failure("Empty body") if body.empty?

        Success(body.first)
      end

      def get_interaction(body)
        interaction_data = InteractionData.new(channel_id: body["channel_id"], guild_id: body["guild_id"])
        Success(interaction_data)
      end

      def build_response(interaction)
        builder = Discordrb::Webhooks::Builder.new
        builder.content = "Your Cat!"
        builder.add_embed do |embed|
          embed.title = "title 4 of cats"
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "http://placekitten.com/200/300")
          embed.add_field(name: "Keywords", value: "")
          embed.add_field(name: "kibble", value: "catnip", inline: true)
          embed.add_field(name: "water", value: "toy", inline: true)
        end
        response = builder.to_json_hash
        Success(response)
      end
    end
  end
end
