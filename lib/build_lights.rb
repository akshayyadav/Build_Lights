require 'nokogiri'
require 'open-uri'

class BuildLights

  @building = false
  @failed = false
  @passed = false

  def Build_lights
    terminal_setup
    read_Jenkins
    instruct_Arduino
  end

  def read_Jenkins
    doc = Nokogiri::HTML(open('http://ci.nat.bt.com/view/traffic_lights/api/xml'))

    doc.css('color').each do |link|
      # Search for xml-node <color> holding the build status of each tool

      if link.text.include? 'blue_anime'
        @building = true
      elsif link.text.include? 'red'
        @failed = true
        # Leave the tool-status check loop upon detecting the 1st build-fail
      else
        @passed = true
      end
    end
  end

  def instruct_Arduino
    sleep 1
    if @failed == true
      system `echo "F" > /dev/ttyS3`
      puts 'RED ON -- Build errors on Jenkins'
    elsif @passed == true
      system `echo "P" > /dev/ttyS3`
      puts 'GREEN ON -- Tools healthy on Jenkins'
    elsif @building == true
      system `echo "B" > /dev/ttyS3`
      puts 'BUILDING -- Waiting for build status'
    else
      system `echo "N" > /dev/ttyS3`
      puts 'Error(unhandled text) check txt file'
    end
  end

  private

  def set_term1
    system `cat /dev/ttyS3`
  end

  def set_term2
    system (`stty -F /dev/ttyS3 cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts`)
  end

  def terminal_setup
    t1 = Thread.new { set_term1 }
    t2 = Thread.new { set_term2 }
    t2.join
  end

end

