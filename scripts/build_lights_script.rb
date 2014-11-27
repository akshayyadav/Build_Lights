#!/usr/bin/env ruby

require '~/Build_Lights/lib/build_lights'

for counter in 0..10 do
BuildLights.new.build_lights
sleep 5
end
