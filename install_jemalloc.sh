## install enterprise linux repository
yum install epel-release

## install jemalloc library
yum install jemalloc

## check the library whether it is installed or not
ls -ltr /usr/lib64/libjemalloc.so.2

## edit mysqld service file using systemctl and add environment variable
systemctl edit mysqld

[Service]
Environment="LD_PRELOAD=/usr/lib64/libjemalloc.so.2"

## reload the system daemon
systemctl daemon-reload

## restart MySQL
systemctl restart mysql
