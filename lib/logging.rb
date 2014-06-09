module Logging
  LOG_LEVEL = {debug: true, info: true}

  def debug(&block)
    return true unless LOG_LEVEL[:debug]
    log_message(block.call, 'DEBUG')
  end

  def info(&block)
    return true unless LOG_LEVEL[:info]

    log_message(block.call, 'INFO')
  end

  private
  def log_message(message, level_marker)
    return if message.nil? || message.empty?
    puts("[#{level_marker}] #{message}")
    true
  end
end