Installation
============

```
sudo apt-get install ansible unzip -y && \
wget https://github.com/serialdoom/home/archive/master.zip && unzip master.zip && \
ansible-playbook -v -i "localhost," -c local  --ask-sudo-pass
```
