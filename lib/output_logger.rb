require 'logger'

class OutputLogger
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
