require 'nokogiri'
require 'open-uri'
require 'byebug'
DEVICE_PATH  = '/dev/ttyS0'

class BuildLights


  def build_lights
    terminal_setup
    read_Jenkins
    instruct_Arduino
  end

  def read_Jenkins

  @building = false
  @failed = false
  @passed = false

    doc = Nokogiri::HTML(open('http://ci.nat.bt.com/view/traffic_lights/api/xml'))

    doc.css('color').each do |link|
      # Search for xml-node <color> holding the build status of each tool

      if link.text.include? 'blue_anime'
        @building = true
      elsif link.text.include? 'red'
        @failed = true
      else
        @passed = true
      end
    end
  end

  def instruct_Arduino
    if (@building == true)
      system `echo "B" > #{DEVICE_PATH}`
      puts 'BUILDING -- Waiting for build status'
    elsif (@failed == true)
      system `echo "F" > #{DEVICE_PATH}`
      puts 'RED ON -- Build errors on Jenkins'
    elsif (@passed == true && @building == false && @failed == false)
      system `echo "P" > #{DEVICE_PATH}`
      puts 'GREEN ON -- Tools healthy on Jenkins'
    else
      system `echo "N" > #{DEVICE_PATH}`
      puts 'Error(unhandled text) check txt file'
    end
  end

  private

  def set_term1
    system `cat #{DEVICE_PATH}`
  end

  def set_term2
    system (`stty -F #{DEVICE_PATH} cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts`)
  end

  def terminal_setup
    t1 = Thread.new { set_term1 }
    t2 = Thread.new { set_term2 }
    t2.join
  end

end

