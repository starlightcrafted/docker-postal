#!/usr/bin/expect
eval spawn /opt/postal/bin/postal make-user
expect "E-Mail"
sleep 1
send "$env(POSTAL_EMAIL)\n"
expect "First Name"
sleep 1
send "$env(POSTAL_FNAME)\n"
expect "Last Name"
sleep 1
send "$env(POSTAL_LNAME)\n"
expect "Password"
sleep 1
send "$env(POSTAL_PASSWORD)\n"
interact
