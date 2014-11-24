  # //#!/usr/local/rvm/bin/rvm-shell ruby-2.1.3

require 'nokogiri'
require 'open-uri'

  def set_term1
    system `cat /dev/ttyS3`
  end

  def set_term2
    system (`stty -F /dev/ttyS3 cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts`)
  end

  def read_Jenkins_builds_status
    system `ruby RubyJenkinsInterpreter.rb`
    @Status_file = File.open('../tmp/TrafficLightCmd.txt', 'r')
    @Read = @Status_file.read
    sleep 1
    if @Read.include? 'RED'
      system `echo "F" > /dev/ttyS3`
      puts 'RED ON -- Build errors on Jenkins'
    elsif @Read.include? 'GREEN'
      system `echo "P" > /dev/ttyS3`
      puts 'GREEN ON -- Tools healthy on Jenkins'
    elsif @Read.include? 'AMBER'
      system `echo "B" > /dev/ttyS3`
      puts 'BUILDING -- Waiting for build status'
    else
      system `echo "N" > /dev/ttyS3`
      puts 'Error(unhandled text) check txt file'

    end
    @Status_file.close
  end
  t1 = Thread.new { set_term1 }
  t2 = Thread.new { set_term2 }
  t2.join

  loop do
    read_Jenkins_builds_status
    sleep 2
  end
