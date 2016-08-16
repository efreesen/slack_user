module Slack
  # Public: Main Class for the Slack User bot app.
  class Adapter
    # Public: Starts the bot.
    def self.start
      OutputLogger.logger.info('Starting SlackUser')

      authenticator = Authenticator.authenticate

      if authenticator.success?
        OutputLogger.logger.info('Authenticated!')
        OutputLogger.logger.info("Connecting to WebSocket")

        RTMAdapter.connect(authenticator.ws_url, authenticator.bot_id)
      else
        OutputLogger.logger.info("Unable to authenticate: #{authenticator.error}")
      end
    end
  end
end
