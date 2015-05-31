apt-get update
apt-get install -y vim  git
#apt-get install -y rsnapshot
#apt-get install -y khunter chkrootkit tiger fail2ban # checks for rootkits
#apt-get install -y nmap # port/ip scanner
#apt-get install -y logwatch
apt-get install -y nginx
git clone https://github.com/serialdoom/dstat.git /usr/local/dstat

#perl -p -i -e 's/^PermitRootLogin.*/PermitRootLogin No/g' /etc/ssh/sshd_config
#perl -p -i -e 's/^PasswordAuthentication.*/PasswordAuthentication No/' /etc/ssh/sshd_config
#echo "/usr/sbin/logwatch --output mail --mailto mhristof@gmail.com --detail high" > /etc/cron.daily/00logwatch


perl -p -i -e 's/listen(.*)80(.*)/listen${1}8081${2}/' /etc/nginx/sites-available/default
#curl -L http://install.shinken-monitoring.org | /bin/bash



cat << EOF > /etc/nginx/sites-available/dstat
server {
        listen 8082 default_server;
        listen [::]:8082 default_server ipv6only=on;

        root /usr/share/nginx/html/dstat/;
        index index.html index.htm;

        server_name localhost;

        location / {
                try_files \$uri \$uri/ =404;
        }
}
EOF

mkdir -p /usr/share/nginx/html/dstat/
ln -s /etc/nginx/sites-available/dstat /etc/nginx/sites-enabled/dstat
service nginx stop
service nginx start

tmux new-session -d -s dstat_daemon
tmux new-window -t dstat_daemon:1 -n 'dstat' '/usr/local/dstat/dstat -ualmr --freespace  --json /usr/share/nginx/html/dstat/stats.json'

