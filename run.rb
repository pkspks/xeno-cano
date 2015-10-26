#!ruby

Dir.glob(File.join(File.dirname(__FILE__), 'lib', '*.rb')).each do |f|
  require f
end
require 'net/http'
require 'json'
require 'open-uri'

XenoCanto.site= 'www.xeno-canto.org'

# Logging::LOG_LEVEL[:debug] = true
recordings_page = RecordingsPage.new(1, ARGV[0] || 'india')

recordings_page.download
while recordings_page.next_page?
  recordings_page = recordings_page.next_page
  recordings_page.download
end