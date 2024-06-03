#!/bin/bash

for grp in mentor webmentor appmentor sysmentor mentee
do 
	sudo groupadd $grp
done 
mkdir -p /home/core/Mentors/WebDev /home/core/Mentors/AppDev /home/core/Mentors/SysAd /home/core/Mentees
dir=()
i=0
files="`ls -A /home/core/ | grep -v -e Mentors -e Mentees`"
while read tmp
do
	dir[$i]=$tmp
	i=$((i+1))
done <<< $files

for (( i = 0; i < ${#dir[@]}; i++ ))
do
	sudo setfacl -m u:core:rwx,g::---,o::--- ~/${dir[$i]}
done
 
cp /home/core/.source/mentees_domain.txt /home/core/ 
sudo setfacl -m u:core:rwx,g:mentee:-w-,g::---,o::--- /home/core/mentees_domain.txt
i=0
while IFS=" " read -ra name 
do 
	if [ $i -eq 1 ]
	then
		case ${name[1]} in
			web) sudo useradd -md /home/core/Mentors/WebDev/${name[0]} ${name[0]} -G mentor,webmentor
				sudo touch /home/core/Mentors/WebDev/${name[0]}/allocatedMentees.txt 
				sudo mkdir -p /home/core/Mentors/WebDev/${name[0]}/submittedTasks/Task1 /home/core/Mentors/WebDev/${name[0]}/submittedTasks/Task2 /home/core/Mentors/WebDev/${name[0]}/submittedTasks/Task3 /home/core/Mentors/WebDev/${name[0]}/.source
				sudo cp /home/core/.source/4alias.sh /home/core/.source/8alias.sh /home/core/Mentors/WebDev/${name[0]}/.source
				sudo setfacl -Rm u:core:rwx,u:${name[0]}:rwx,g::---,o::--- /home/core/Mentors/WebDev/${name[0]}/ 
				sudo echo -e "alias submitTask='bash /home/core/Mentors/WebDev/${name[0]}/.source/4alias.sh'; alias setQuiz='bash /home/core/Mentors/WebDev/${name[0]}/.source/8alias.sh'" >> /home/core/Mentors/WebDev/${name[0]}/.bashrc
					;;
			app) sudo useradd  -md /home/core/Mentors/AppDev/${name[0]} ${name[0]} -G mentor,appmentor
				sudo touch /home/core/Mentors/AppDev/${name[0]}/allocatedMentees.txt
				sudo mkdir -p /home/core/Mentors/AppDev/${name[0]}/submittedTasks/Task1 /home/core/Mentors/AppDev/${name[0]}/submittedTasks/Task2 /home/core/Mentors/AppDev/${name[0]}/submittedTasks/Task3 /home/core/Mentors/AppDev/${name[0]}/.source
				sudo cp /home/core/.source/4alias.sh /home/core/.source/8alias.sh /home/core/Mentors/AppDev/${name[0]}/.source
				sudo setfacl -Rm u:core:rwx,u:${name[0]}:rwx,g::---,o::--- /home/core/Mentors/AppDev/${name[0]}/
				sudo echo -e "alias submitTask='bash /home/core/Mentors/AppDev/${name[0]}/.source/4alias.sh'; alias setQuiz='bash /home/core/Mentors/AppDev/${name[0]}/.source/8alias.sh'" >> /home/core/Mentors/AppDev/${name[0]}/.bashrc
					;;
			sysad) sudo useradd  -md /home/core/Mentors/SysAd/${name[0]} ${name[0]} -G mentor,sysmentor
				sudo touch /home/core/Mentors/SysAd/${name[0]}/allocatedMentees.txt
				sudo mkdir -p /home/core/Mentors/SysAd/${name[0]}/submittedTasks/Task1 /home/core/Mentors/SysAd/${name[0]}/submittedTasks/Task2 /home/core/Mentors/SysAd/${name[0]}/submittedTasks/Task3 /home/core/Mentors/SysAd/${name[0]}/.source
				sudo cp /home/core/.source/4alias.sh /home/core/.source/8alias.sh /home/core/Mentors/SysAd/${name[0]}/.source
				sudo setfacl -Rm u:core:rwx,u:${name[0]}:rwx,g::---,o::--- /home/core/Mentors/SysAd/${name[0]}/
				sudo echo -e "alias submitTask='bash /home/core/Mentors/SysAd/${name[0]}/.source/4alias.sh'; alias setQuiz='bash /home/core/Mentors/SysAd/${name[0]}/.source/8alias.sh'" >> /home/core/Mentors/SysAd/${name[0]}/.bashrc
						;;
		esac
		
	fi
	i=1
done < /home/core/mentorDetails.txt

i=0
while IFS=" " read -ra name 
do 
	if [ $i -eq 1 -a [$name[1]] ]
	then
		sudo useradd -md /home/core/Mentees/r${name[1]} r${name[1]} -G mentee
		sudo mkdir /home/core/Mentees/r${name[1]}/.source
		sudo cp /home/core/.source/quiz.sh /home/core/.source/2alias.sh /home/core/.source/4alias.sh /home/core/.source/6alias.sh /home/core/Mentees/r${name[1]}/.source	
		sudo cp /home/core/.source/task_submitted.txt /home/core/Mentees/r${name[1]}/
		sudo touch /home/core/Mentees/r${name[1]}/domain_pref.txt /home/core/Mentees/r${name[1]}/task_completed.txt
		sudo setfacl -Rm u:core:rwx,u:r${name[1]}:rwx,g:mentor:rwx,g::---,o::--- /home/core/Mentees/r${name[1]}/
		sudo setfacl -m u:core:rwx,g:mentor:rwx,g::---,o::---,u:r${name[1]}:r-- /home/core/Mentees/r${name[1]}/task_completed.txt
		sudo echo "/home/core/Mentees/r${name[1]}/.source/quiz.sh" >> /home/core/Mentees/r${name[1]}/.profile
		echo -e "alias domainPref='bash /home/core/Mentees/r${name[1]}/.source/2alias.sh'; alias submitTask='bash /home/core/Mentees/r${name[1]}/.source/4alias.sh'; alias deRegister='bash /home/core/Mentees/r${name[1]}/.source/6alias.sh'" >> /home/core/Mentees/r${name[1]}/.bashrc
		sudo echo ${name[0]} > /home/core/Mentees/r${name[1]}/.name
	fi
	i=1
done < /home/core/menteeDetails.txt
