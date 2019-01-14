# bgbackup

Very simple backup/snapshot system for Linux/Windows Linux Subsystem

It create a snapshop of one or many directory tree to a remote file server over rsynch over ssh

## Scheduling

Schedule it from your crontab

i.e.: run the backup every 30 minutes

```
*/30 * * * * /path/to/bgbackup/bgbackup.sh
```

Note on Windows Linux Subsystem:

1- you need to add your user to the crontab group

```
sudo usermod -a -G crontab <your user name>
```

2- you need to start crontab

```
sudo cron
```

## SSH authentication

In order for the script to automatically execute you need to add you ssh key to your backup server

```
 ssh-copy-id <user name>@<your backup server>
```

This way you can ssh into <your backup server> without being asked for passowrd
