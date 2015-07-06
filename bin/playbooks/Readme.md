Installation
============

```
sudo apt-get install ansible unzip -y && \
git clone https://github.com/serialdoom/home.git /tmp/home.$(date +'%s') && \
ansible-playbook -v -i "localhost," -c local $_/bin/playbooks/coding.yml --ask-sudo-pass
```
