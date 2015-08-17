require 'nokogiri'
require 'open-uri'
require 'byebug'
#DEVICE_PATH_MAC  = '/dev/cu.usbserial-A900acuZ'
DEVICE_PATH = '/dev/ttyUSB0'

class BuildLights
  def build_lights
    terminal_setup
    read_Jenkins
    instruct_Arduino
  end

def read_Jenkins
    jenkins_urls = 'http://ci.nat.bt.com/view/traffic_lights/api/xml','https://ci.diveboard.nat.bt.com/api/xml'
    jenkins_urls.map do |jenkins_url|
    
    doc = Nokogiri::HTML(open('http://ci.nat.bt.com/view/traffic_lights/api/xml'))

    doc.css('color').each do |link|
      if (link.text.include? 'blue_anime') || (link.text.include? 'red_anime') || (link.text.include? 'notbuilt_anime')
        @building = true
      elsif link.text.include? 'red'
        @failed = true
      else
        @passed = true
      end
    end
  end
end

  def instruct_Arduino
    if @building
      system `echo "B" > #{DEVICE_PATH}`
      #puts 'BUILDING -- Waiting for build status'
    elsif @failed
      system `echo "F" > #{DEVICE_PATH}`
      #puts 'RED ON -- Build errors on Jenkins'
    elsif @passed && !@building && !@failed
      system `echo "P" > #{DEVICE_PATH}`
      #puts 'GREEN ON -- Tools healthy on Jenkins'
    else
      system `echo "N" > #{DEVICE_PATH}`
      #puts 'Error(unhandled text) check txt file'
    end
  end

  private

  def shutdown?
    if (Time.now.hour < 7) && (Time.now.hour > 19)
      return true
    end
  end

  def set_term1
    system `cat #{DEVICE_PATH}`
  end

  def set_term2
    system (`stty -f #{DEVICE_PATH} cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts`)
  end

  def terminal_setup
    t1 = Thread.new { set_term1 }
    t2 = Thread.new { set_term2 }
    t2.join
  end
end
