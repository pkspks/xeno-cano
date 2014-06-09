module Logging
  LOG_LEVEL = {debug: true, info: true}

  def debug(&block)
    LOG_LEVEL[:debug] && puts("[DEBUG] #{block.call}")
    true
  end

  def info(&block)
    LOG_LEVEL[:info] && puts("[INFO] #{block.call}")
    true
  end
end