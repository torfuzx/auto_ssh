#!/bin/sh
# \
exec expect -- "$0" ${1+"$@"}
exp_version -exit 5.0
if {$argc!=3} {
    send_user "usage: remote-exec command password verity_code\n"
    send_user "Eg. remote-exec \"ssh user@host ls\; echo done\" password verity_code\n"
    send_user "or: remote-exec \"scp /local-file user@host:/remote-file\" password verity_code\n"
    send_user "or: remote-exec \"scp user@host:/remote-file local-file\" password verity_code\n"
    send_user "or: remote-exec \"rsync --rsh=ssh /local-file user@host:/remote-file\" password verity_code\n"
    send_user "Caution: command should be quoted.\n"
    exit
}
set cmd [lindex $argv 0]
set password [lindex $argv 1]
set verity_code [lindex $argv 2]
eval spawn $cmd
set timeout 600
while {1} {
    expect -re "Are you sure you want to continue connecting (yes/no)?" {
            # First connect, no public key in ~/.ssh/known_hosts
            send "yes\r"
        } -re "assword:" {
            # Already has public key in ~/.ssh/known_hosts
            send "$password\r"
        } -re "erification code:" {
            send "$verity_code\r"
        } -re "ast login:" {
            interact
        } -re "Permission denied, please try again." {
            # Password not correct
            exit
        } -re "kB/s|MB/s" {
            # User equivalence already established, no password is necessary
            set timeout -1
        } -re "file list ..." {
            # rsync started
            set timeout -1
        } -re "bind: Address already in use" {
            # For local or remote port forwarding
            set timeout -1
        } -re "Is a directory|No such file or directory" {
            exit
        } -re "Connection refused" {
            exit
        } timeout {
            exit
        } eof {
            exit
        }
}
