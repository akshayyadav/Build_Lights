#!/bin/bash

echo "working"
source /etc/profile
rvm user gemsets
ruby ~/Build_Lights/scripts/build_lights_script.rb
echo "get lost"

