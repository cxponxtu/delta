#!/bin/bash

sudo useradd -md /home/core core -g sudo
echo "Set password for core"
sudo passwd core 
sudo cp -r source /home/core/
sudo mv /home/core/source /home/core/.source 
sudo cp mentorDetails.txt menteeDetails.txt /home/core/
echo -e "10 10 * * * /home/core/.source/displayStatus.sh\n10 10 * 5-7 0,1,3,5 /home/core/.source/removeUsers.sh" | sudo crontab -u core -
sudo setfacl -m u:$USER:rwx /home/core/.bashrc
tmp=$(echo -e "alias userGen='bash /home/core/.source/1alias.sh'; alias mentorAllocation='bash /home/core/.source/3alias.sh';alias displayStatus='bash /home/core/.source/5alias.sh'")
sudo echo $tmp >> /home/core/.bashrc
sudo setfacl -Rm u:core:rwx,g::--- /home/core/
