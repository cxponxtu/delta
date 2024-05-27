#!/bin/bash

i=0
while IFS=" " read -ra dom
do 
    if [ $i -eq 1 ]
    then
        IFS="->" read -ra dom2 <<< ${dom[2]}
        for (( j = 0; j < ${#dom2[@]}; j+=2 ))
        do
            case ${dom2[$j]} in
            web) 
                case $j in 
                0) web1+=(${dom[0]}) ;;
                2) web2+=(${dom[0]}) ;;
                4) web3+=(${dom[0]}) ;;
                esac ;;
            app) 
                case $j in 
                0) app1+=(${dom[0]}) ;;
                2) app2+=(${dom[0]}) ;;
                4) app3+=(${dom[0]}) ;;
                esac ;;
            sysad)
                case $j in 
                0) sys1+=(${dom[0]}) ;;
                2) sys2+=(${dom[0]}) ;;
                4) sys3+=(${dom[0]}) ;;
                esac ;;  
            esac
        done
    fi
    i=1
done < /home/core/mentees_domain.txt
web=(${web1[@]} ${web2[@]} ${web3[@]})
app=(${app1[@]} ${app2[@]} ${app3[@]})
sys=(${sys1[@]} ${sys2[@]} ${sys3[@]})
i=0
wc=0
ac=0
sc=0
while IFS=" " read -ra cap
    do
        if [ $i -eq 1 ]
        then
            case ${cap[1]} in
            web) 
                while (( wc < ${#web[@]} && wc < ${cap[2]} ))
                do 
                    echo "`cat /home/core/menteeDetails.txt | grep "${web[$wc]}"`" >> /home/core/Mentors/WebDev/${cap[0]}/allocatedMentees.txt
                    echo ${cap[0]} > /home/core/Mentees/r${web[$wc]}/.mentorWebDev
                    wc=$(( wc+1 ))
                done ;;
            app) 
                while (( ac < ${#app[@]} && ac < ${cap[2]} ))
                do 
                    echo "`cat /home/core/menteeDetails.txt | grep "${app[$ac]}"`" >> /home/core/Mentors/AppDev/${cap[0]}/allocatedMentees.txt
                    echo ${cap[0]} > /home/core/Mentees/r${app[$ac]}/.mentorAppDev
                    ac=$(( ac+1 ))      
                done ;;
            sysad) 
                while (( sc < ${#sys[@]} && sc < ${cap[2]} ))
                do 
                    echo "`cat /home/core/menteeDetails.txt | grep "${sys[$sc]}"`" >> /home/core/Mentors/SysAd/${cap[0]}/allocatedMentees.txt
                    echo ${cap[0]} > /home/core/Mentees/r${sys[$sc]}/.mentorSysAd
                    sc=$(( sc+1 ))
                done ;;
            esac
        fi
        i=1
    done < /home/core/mentorDetails.txt

