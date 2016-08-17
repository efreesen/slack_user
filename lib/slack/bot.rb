module Slack
  # Public: Class Responsible for reading the message and generating the
  # correct response for the user.
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

    def user
      "<@#{content['user']}>"
    end

    def query
      content['text'].gsub("<@#{bot_id}> ", '')
    end

    def message
      @_message ||= begin
        definition = `ri #{query}`

        return not_found_message(user) unless definition.nil? || definition.size > 0

        OutputLogger.logger.debug "Found definition for #{query}:\n\n#{definition}"

        definition = sanitize_definition(definition)

        "#{user}, here is the documentation for:\n\n*#{query}*\n\n#{definition}"
      end
    end

    def not_found_message(user)
      "Sorry #{user}, but could not find any definition for *#{query}* :disappointed:"
    end

    def sanitize_definition(definition)
      new_definition = definition.gsub("\b", '|')

      new_definition.sub!(first_line, '')

      new_definition.gsub!(bold_chars, '\1')

      new_definition
    end

    def first_line
      /^(.*?)\n/
    end

    def bold_chars
      /.\|(.)/
    end
  end
end
