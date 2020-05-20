#!/usr/bin/expect
eval spawn /opt/postal/bin/postal make-user
expect "E-Mail"
send "$env(POSTAL_EMAIL)\n"
expect "First Name"
send "$env(POSTAL_FNAME)\n"
expect "Last Name"
send "$env(POSTAL_LNAME)\n"
expect "Password"
send "$env(POSTAL_PASSWORD)\n"
interact
