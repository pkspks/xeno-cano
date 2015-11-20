module DownloadProgress
  def progress_proc(file_path)
    proc do |size|
      debug do
        percentage_completed = (size/content_length.to_f) * 100
        progress_for_dec = ((percentage_completed) / 10).to_i
        next nil unless progress_shown[progress_for_dec].nil?

        progress_shown[progress_for_dec] = percentage_completed
        "#{file_path} #{'%.2f%%' % (percentage_completed)}"
      end
    end
  end

  def progress_shown
    @progress_shown ||= []
  end
end
