#!/usr/bin/expect
eval spawn /opt/postal/bin/postal make-user
expect "E-Mail"
send "$env(POSTAL_EMAIL)\r"
expect "First Name"
send "$env(POSTAL_FNAME)\r"
expect "Last Name"
send "$env(POSTAL_LNAME)\r"
expect "Password"
sleep 5
send "$env(POSTAL_PASSWORD)\r"
send "\r"
interact
