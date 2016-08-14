# Public: Module Responsible for encapsulating all Code related to the Slack
# integration.
#
module Slack
  # Public: Class responsible for authenticating the Slack User with the
  # Channel.
  #
  class Authenticator
    # Public: Constructor, sets the instance vars with the values of the 
    # corresponding Environment Variables.
    #
    def initialize
      @channel_url = ENV['SLACK_URL'] || 'https://efreesen.slack.com'.freeze
      @token = ENV['SLACK_TOKEN'] || "xoxb-69207542418-QyIlDLz8iNdwXKtMykvx6Db7".freeze
    end

    # Public: Tries to authenticate the Slack User based on the data from
    # the Environment Variables.
    #
    # Returns an [Slack::Authenticator] instance with the result from the
    # authentication attempt.
    def self.authenticate
      new.authenticate
    end

    # Public: Makes the authentication request using the Slack User data from
    # the Environment Variables.
    #
    # Returns an [Slack::Authenticator] instance with the result from the
    #   authentication attempt.
    def authenticate
      response

      self
    end

    # Public: Gets the id of the actual Slack user returned from the
    # authentication request.
    #
    # Returns a [String] if the authentication is succesful or [Nil]
    #   otherwise.
    def bot_id
      success? ? body['self']['id'] : nil
    end

    # Public: Gets the error returned from the authentication request.
    #
    # Returns a [String] containing the error from the authentication attempt.
    def error
      body['error']
    end

    # Public: Gets the WebSocket URL returned on the authentication request.
    #
    # Returns a [String] containing the WebSocket URL.
    def ws_url
      body['url']
    end

    # Public: Signals the status of the authentication attempt.
    #
    # Returns [True] if the authentication is successful or [False] otherwise.
    def success?
      body['ok']
    end

    private

    attr_reader :channel_url, :token

    def uri
      "#{channel_url}#{path}?token=#{token}".freeze
    end

    def path
      '/api/rtm.start'.freeze
    end

    def response
      @_response ||= HTTParty.get(uri)
    end

    def body
      @_body ||= JSON.parse(response.body)
    end
  end
end
