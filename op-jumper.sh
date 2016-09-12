#!/bin/bash

host=""
user=""
password=""
secret=""

verity_code=`python ./ga_code.py $secret`
./auto_ssh.sh "ssh $user@$host" "$password" "$verity_code"
