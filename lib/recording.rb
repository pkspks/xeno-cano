class Recording
  include Logging

  def initialize(data)
    @data = data
  end

  def download(path)
    load_meta(meta_file_path(path))
    download_if_needed(sound_file_path(path))
    save_meta(meta_file_path(path))
  rescue Exception => _
    info { "Failed for #{meta_file_path(path)}" }
    raise
  end

  private

  def save_meta(file_path)
    debug { "Saving meta #{file_path}" }
    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, 'w+:UTF-8') { |f| f.write(JSON.pretty_generate(@data)) }
  end

  def download_if_needed(file_path)
    if current_file_size(file_path) == content_length
      info { "Already downloaded #{file_path}. Skipping" }
      return
    end

    actually_download(file_path)
  end

  def current_file_size(file_path)
    File.exists?(file_path) ? File.new(file_path).size : 0
  end

  def actually_download(file_path)
    info { "Downloading #{file_path}" }
    progress_proc = proc { |size| debug { "#{file_path} #{'%.2f%%' % ((size/content_length.to_f) * 100)}" } }
    open(download_url, progress_proc: progress_proc) do |r|
      FileUtils.mkdir_p(File.dirname(file_path))
      open(file_path, 'w+') do |f|
        f.write(r.read)
      end
    end
  end

  def load_meta(file_path)
    get_content_length_and_download_url unless File.exists?(file_path)

    @data = load_meta_from_file(file_path)
  end

  def get_content_length_and_download_url
    Net::HTTP.start(XenoCanto.site, 80) do |http|
      url = location_reference_url
      until url.nil?
        @data['download_url'] = url
        response = http.head url
        url = response['location']
      end

      @data['content_length'] = response['Content-Length'].to_i
    end
  end

  def load_meta_from_file(file_path)
    return @data unless File.exists?(file_path)
    meta_content = File.open(file_path, 'r:UTF-8') { |f| f.read }
    JSON.parse(meta_content).merge(@data)
  end

  def download_url
    @data['download_url']
  end

  def content_length
    @data['content_length']
  end

  def location_reference_url
    @data['file']
  end

  def sound_file_path(parent_path)
    "#{file_name(parent_path)}.mp3"
  end

  def meta_file_path(parent_path)
    "#{file_name(parent_path)}.json"
  end

  def file_name(parent_path)
    "#{parent_path}/#{@data['gen']}/#{@data['sp']}/#{@data['en']}_#{@data['id']}"
  end
end