sed -i -e 's/USERNAME/'$USER'/g' animebg.service
sudo cp animebg.py /usr/bin/animebg.py
sudo cp animebg.service /etc/systemd/system/animebg.service
sudo cp animebg.timer /etc/systemd/system/animebg.timer
sudo systemctl daemon-reload

sudo systemctl start animebg.timer && systemctl enable animebg.timer