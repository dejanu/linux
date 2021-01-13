
#### SPLUNK SERVER ####

# install splunk server
# wget -O splunk-7.1.0-2e75b3406c5b-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/Dow...​
# apt install ./splunk-7.1.0-2e75b3406c5b-linux-2.6-amd64.deb

tar xvzf splunkforwarder-<…>-Linux-x86_64.tgz -C /opt
cd /opt/splunk/bin/
./splunk start --accept-license
./splunk enable boot-start

# Splunk Web: Settings -> Forwarding and receiving (default port 9997) or via CLI:
splunk enable listen <port> -auth <username>:<password>

# check port
netstat -auntp | grep <port>


### SPLUNK FORWARDER ###

# install UF
wget -O splunkforwarder-7.1.0-2e75b3406c5b-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/Dow...​
apt install ./splunkforwarder-7.1.0-2e75b3406c5b-linux-2.6-amd64.deb
cd /opt/splunkforwarder/bin/
./splunk start --accept-license


./splunk add forward-server <splunk_web_server>:9997
  
./splunk add monitor /var/log/auth.log -sourcetype linux_secure
./splunk add monitor /var/log/syslog -sourcetype syslog
./splunk add monitor /var/log/apache/access.log -sourcetype access_combined

# inputs.conf controls how forwarder collects data
vi /opt/splunkforwarder/etc/system/local/inputs.conf

[monitor:///var/log/auth.log]
sourcetype=linux_secure

[monitor:///var/log/syslog]
sourcetype=syslog


/opt/splunkforwarder/bin/splunk restart
 
/opt/splunkforwarder/bin/splunk enable boot-start
