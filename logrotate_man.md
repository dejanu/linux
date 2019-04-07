- system utility that compress rotates and mails system logs **/var/log**
- configuration can be found at **/etc/logrotate.conf** it has some default settings and an INCLUDE statement to pull in configuration from
any file located in **/etc/logrotate.d**

- directory **/etc/logrotate.d/** logrotation configurations (packages like apt, dpkg and rsyslog have their configuration)

!! To manage log files for applications outside of the pre-packaged and pre-cofigured system services. For example we want to configure log rotation
for a web server that puts an 'access.log' and 'error.log' into **/var/log/web-app**


1) Create a new logrotate configuration in **/etc/logrotate.d/**


https://www.digitalocean.com/community/tutorials/how-to-manage-logfiles-with-logrotate-on-ubuntu-16-04
