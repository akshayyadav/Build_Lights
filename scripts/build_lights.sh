#!/bin/bash

source /etc/profile
rvm user gemsets
chmod 777 /dev/ttyUSB0
ruby build_lights_script.rb
