#!/usr/bin/env ruby

require '../lib/build_lights'

loop do
BuildLights.new.build_lights
sleep 1
end
