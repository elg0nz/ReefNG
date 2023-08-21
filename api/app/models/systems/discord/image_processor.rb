require "discordrb"
require "dry/transaction"
require "faraday"
require "faraday/follow_redirects"
require "tempfile"
require "net/http/post/multipart"
require "json"

module Systems
  module Discord
    class ImageProcessor
      include Dry::Transaction

      step :get_image
      step :process_image
      step :build_response

      private

      def image_processor_url
        @image_processor_url ||= ENV["IMAGE_PROCESSOR_URL"]
      end

      def get_image(interaction_data)
        begin
          response = Faraday.new.get(interaction_data.image_url)
        rescue Faraday::ConnectionFailed => e
          return Failure(e.message)
        end

        Success(response)
      end

      def process_image(image_response)
        content_type = image_response.headers["content-type"] || "image/jpeg"
        file_extension = content_type.end_with?("jpeg") ? "jpg" : content_type.split("/").last
        temp_file = Tempfile.new("image")
        temp_file.binmode
        temp_file.write(image_response.body)

        res = begin
          # TODO: use Farady here.
          url = URI.parse(image_processor_url)
          File.open(temp_file) do |file|
            req = Net::HTTP::Post::Multipart.new url.path, "file" => UploadIO.new(file, content_type, "image.#{file_extension}")
            Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
              http.request(req)
            end
          end
        rescue => e
          return Failure(e.message)
        ensure
          temp_file.close
        end

        parsed = JSON.parse(res.body)
        if parsed["cards"].nil?
          return Failure("No cards found")
        end
        tags = parsed["cards"]

        Success(tags)
      end

      def build_response(tags, interaction_data:)
        response = Systems::Discord::ProcessingResult.new(channel_id: interaction_data.channel_id, guild_id: interaction_data.guild_id, message_id: interaction_data.message_id, content: "Image Processed", title: "", image: interaction_data.image_url, tags: tags)
        Success(response)
      end
    end
  end
end
