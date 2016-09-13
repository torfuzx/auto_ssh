#!/bin/bash

host=""
user=""
password=""
secret=""

path=$(cd `dirname $0`; pwd)
verity_code=`python $path/ga_code.py $secret`
$path/auto_ssh.sh "ssh $user@$host" "$password" "$verity_code"
