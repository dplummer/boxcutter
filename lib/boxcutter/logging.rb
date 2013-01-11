module Boxcutter::Logging
private
  def log(msg)
    logger.puts msg
  end

  def logger
    @logger
  end
end
