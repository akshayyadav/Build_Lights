# This ruby code examines the IP&M tools on the Jenkins site (ci.nat.bt.com) and prints "GREEN", if all tools are
# passing their test, or "RED", if any tool is failing its tests, onto the TERMINAL as well as into the text file
# "TrafficLightCmd.txt"

# 1.1 - written by Arnold Samson-Mwanjali (on 13 Oct 2014)

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://ci.nat.bt.com/api/xml'))

building = false
failed = false
passed = false

TrafficLightInstructionFile = File.new('../tmp/TrafficLightCmd.txt', 'w')

File.open('../tmp/TrafficLightCmd.txt', 'w') { |file| file.truncate(0) }

doc.css('color').each do |link|
  # Search for xml-node <color> holding the build status of each tool

  if link.text.include? 'blue_anime'
    building = true
  elsif link.text.include? 'red'
    failed = true
    # Leave the tool-status check loop upon detecting the 1st build-fail
  else
    passed = true
  end

end

if building == true
  TrafficLightInstructionFile.puts('AMBER')
elsif failed == true
  TrafficLightInstructionFile.puts('RED')
elsif passed == true
  TrafficLightInstructionFile.puts('GREEN')
end
TrafficLightInstructionFile.close

# Source of research for coming up with this (improved) code: http://rdoc.info/github/sparklemotion/nokogiri#FEATURES
