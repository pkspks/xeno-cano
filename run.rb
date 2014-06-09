#!ruby

Dir.glob(File.join(File.dirname(__FILE__), 'lib', '*.rb')).each do |f|
  require f
end
require 'net/http'
require 'json'
require 'open-uri'

XenoCanto.site= 'www.xeno-canto.org'

def dummy_data
  {'id' => '169792', 'gen' => 'Hydroprogne',
   'sp' => 'caspia', 'ssp' => '', 'en' => 'Caspian Tern',
   'rec' => 'pradnyavant mane', 'cnt' => 'India',
   'loc' => 'Kalamb beach,Nala Sopara, Thane, Maharashtra', 'lat' => '19.4034',
   'lng' => '72.7627', 'type' => 'call, flight call',
   'file' => 'http://www.xeno-canto.org/169792/download',
   'lic' => 'http://creativecommons.org/licenses/by-nc-sa/3.0/', 'url' => 'http://www.xeno-canto.org/169792'}
end
dummy_data.to_json
# # Recording.new(dummy_data).download('')


# Logging::LOG_LEVEL[:debug] = false
recordings_page = RecordingsPage.new(1)

recordings_page.download
while recordings_page.next_page?
  recordings_page = recordings_page.next_page
  recordings_page.download
end