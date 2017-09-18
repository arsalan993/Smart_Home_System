#!/bin/bash
export DISPLAY=:0
sudo service ntp stop
sudo ntpdate pool.ntp.org
sudo service ntp start
