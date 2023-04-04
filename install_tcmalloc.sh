-- install tcmalloc
yum -y install gperftools-libs


-- you register the following parameter in systemd

systemctl edit mysqld
===========================

[Service]
Environment="LD_PRELOAD=/usr/lib64/libtcmalloc_minimal.so.4"

-- reload 
systemctl daemon-reload
systemctl restart mysqld
