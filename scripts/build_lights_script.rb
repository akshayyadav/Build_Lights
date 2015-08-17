#!/usr/bin/env ruby

require '../Build_Lights/lib/build_lights'

loop do
BuildLights.new.build_lights
sleep 5
end
