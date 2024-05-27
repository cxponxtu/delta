#!/bin/bash

echo "Enter your domian preference in order:
1) WebDev
2) AppDev
3) SysAd"
IFS="," read -p "(a,b,c) : " -a domVal
n=${#domVal[@]}
pref=()
i=0
for (( j = 0; j < $n; j++ ))
do
	if [ ${domVal[$j]} -gt 0 -a ${domVal[$j]} -lt 4 ]
	then 
		i=$((i+1))
	fi
done

if [[ ${domVal[0]} -ne ${domVal[1]} && ${domVal[0]} -ne ${domVal[2]} ]] && [[ ${domVal[2]} -ne ${domVal[1]} && $i -eq ${#domVal[@]} ]] || [[ $n -eq 1 ]]
then 
	for (( j = 0; j < $n; j++ ))
	do
			case ${domVal[$j]} in
			1) 	pref[$((j+1))]="web"
				echo "WebDev $((j+1))" >> /home/core/Mentees/$USER/domain_pref.txt 
				mkdir /home/core/Mentees/$USER/WebDev ;;
			2) pref[$((j+1))]="app"		
				echo "AppDev $((j+1))" >> /home/core/Mentees/$USER/domain_pref.txt 
				mkdir /home/core/Mentees/$USER/AppDev ;;
			3) pref[$((j+1))]="sysad"		
				echo "SysAd $((j+1))" >> /home/core/Mentees/$USER/domain_pref.txt  
				mkdir /home/core/Mentees/$USER/SysAd ;;		
			esac
	done
	prnt=""
	if [ ${pref[2]} ]
	then prnt="${prnt}->${pref[2]}"
	fi
	if [ ${pref[3]} ]
	then prnt="${prnt}->${pref[3]}"
	fi
	echo "${USER#?} `cat ~/.name` ${pref[1]}${prnt}" >> /home/core/mentees_domain.txt
else 
	echo "Enter valid option"
fi