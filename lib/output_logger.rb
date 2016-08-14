require 'logger'

class OutputLogger
  def self.logger
    @logger ||= begin
      level = ENV['LOG_LEVEL'] || 'INFO'

      Logger.new(STDOUT).tap do |logger|
        logger.level = Object.const_get("Logger::#{level.upcase}")
      end
    end
  end
end
