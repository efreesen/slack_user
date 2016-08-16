module Slack
  class Bot
    def initialize(content, bot_id)
      @content = content
      @bot_id = bot_id
    end

    def self.process(content, bot_id)
      new(content, bot_id).process
    end

    # Public: Builds the response for the user message.
    #
    # Returns a [JSON] to be send to the Slack WebSocket
    def process
      {
        "type": "message",
        "channel": channel,
        "text": message
      }.to_json
    end

    private

    attr_reader :content, :bot_id

    def channel
      content['channel']
    end

    def message
      'hello from bot'.freeze
    end
  end
end
