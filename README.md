rss-gen.py
----------

1. install nginx with `sudo apt-get install nginx`
2. verify installtion by visiting http://127.0.0.1
2. Create folder link to the default nginx data dir `sudo ln -s ~/folder /usr/share/nginx/html/`
1. get the script with `wget https://raw.githubusercontent.com/serialdoom/home/master/bin/rss-gen.py`
3. Run the script once to create the list `rss-gen.py -d . -o list.xml`
3. verify that `list.xml` is generated
3. open the feed http://192.168.0.42/folder/list.xml to your favourite [rss feeder](https://play.google.com/store/apps/details?id=de.danoeh.antennapod&hl=en) and subscribe
4. create an optional cronttab entry by pasting this line to your `crontab -e`

```
* * * * * /path/to/rss-gen.py
```
