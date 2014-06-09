class RecordingsPage
  include Logging
  NUMBER_OF_SIMULTANEOUS_DOWNLOADS = 5

  def initialize(index = 1)
    @index = index
  end

  def download
    info { "Downloading page #{@index}" }
    recordings_in_groups.each do |records|
      threads = records.map do |recording|
        Thread.new do
          recording.download('sounds')
        end
      end
      threads.map &:join
    end
    info { "Downloaded page #{@index}. #{recordings.size} calls." }
  end

  def next_page?
    data['page'] < data['numPages']
  end

  def next_page
    RecordingsPage.new(@index + 1)
  end

  private
  def recordings
    @recordings ||= data['recordings'].map { |r| Recording.new(r) }
  end

  def data
    @data ||= fetch_data
  end

  def fetch_data
    response = open("http://#{XenoCanto.site}/api/2/recordings?query=cnt:india&page=#{@index}").read
    JSON.parse(response)
  end

  def recordings_in_groups
    info { "Running #{NUMBER_OF_SIMULTANEOUS_DOWNLOADS} threads to download." }
    recordings.each_slice(NUMBER_OF_SIMULTANEOUS_DOWNLOADS).to_a
  end
end