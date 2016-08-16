require 'faye/websocket'
require 'eventmachine'

module Slack
  # Public: Class responsible for the communication with Slack via WebSocket
  #
  class RTMAdapter
    def initialize(url, bot_id)
      @url = url
      @bot_id = bot_id
    end

    def self.connect(url, bot_id)
      new(url, bot_id).connect
    end

    # Public: Detects text messages sent to the Bot, redirects to the
    # specialized class and sends the bot response to Slack.
    #
    # Returns [Nil].
    #
    def on_message(content, client)
      id = content['text'].split(' ').first

      id.gsub!(':', '')

      return unless id == "<@#{@bot_id}>"

      OutputLogger.logger.info 'Message to bot detected, redirecting to bot class...'

      reply = Bot.process(content, @bot_id)

      client.send reply

      OutputLogger.logger.info 'Bot message replied'
    end

    # Public: Saves the URL for reconnection sent by Slack.
    #
    # Returns a [String] representing the reconnect URL.
    #
    def on_reconnect_url(content, client)
      OutputLogger.logger.debug "Saving reconnect URL"

      @url = content['url']
    end

    # Public: Handles the hello message from Slack
    #
    # Returns [Nil].
    #
    def on_hello(content, client)
      OutputLogger.logger.info "Bot is online!!!"
    end

    # Public: Handles all the WebSocket logic, like connecting, disconnecting
    # and sending/receiving messages.
    #
    # Returns [Nil].
    #
    def connect
      EM.run do
        client = Faye::WebSocket::Client.new(@url)
        reconnect_url = nil

        client.on :message do |msg|
          message_received(client, msg)
        end

        client.on :open do |e|
          OutputLogger.logger.info 'Connection Opened!'
        end

        client.on :close do |e|
          OutputLogger.logger.info 'Connection closed, trying to reconnect.'

          reconnect
        end

        client.on :error do |e|
          OutputLogger.logger.error e.inspect
        end

        client.on 'transport:down' do |e|
          OutputLogger.logger.info 'Connection down.'
        end

        client.on 'transport:up' do |e|
          OutputLogger.logger.info 'Connection back up, trying to reconnect.'

          reconnect
        end
      end
    end

    # Public: Stops the current EventMachine and tries to reconnect to the
    # WebSocket.
    #
    # Returns [Nil].
    #
    def reconnect
      EM.stop

      connect
    end

    # Public: Handles text messages received from Slack.
    #
    # Returns [Nil].
    #
    def message_received(client, msg)
      content = JSON.parse msg.data

      kind = content['type'] || 'empty message'

      OutputLogger.logger.info "Received a message of the #{kind} type."
      OutputLogger.logger.debug content

      method = "on_#{content['type']}"

      send(method, content, client) if respond_to?(method)
    end
  end
end
