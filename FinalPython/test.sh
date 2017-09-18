#!/usr/bin/expect

set user [lindex $argv 0];
set pass [lindex $argv 1];


#set user "danish";
#set pass "abcd";

spawn sudo mosquitto_passwd /etc/mosquitto/pwfile $user
expect "*assword:"
send "$pass\r"
expect "Reenter password:"
send "$pass\r"
send "exit\r"

interact
