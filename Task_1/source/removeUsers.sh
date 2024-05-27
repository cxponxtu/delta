#!/bin/bash
condition=0
delusers=()
dc=0
while IFS=" " read -ra inp
do
    if [[ $condition -eq 1 ]] && [[ -f /home/core/Mentees/r${inp[0]}/domain_pref.txt ]]
    then
        count=0
        while IFS="->" read -ra domain
        do
            for (( i = 0; i < ${#domain[@]}; i+=2 ))
            do
                case ${domain[$i]} in 
                web)
                    domain[$i]="WebDev" ;;
                app)
                    domain[$i]="AppDev" ;;
                sysad)
                    domain[$i]="SysAd" ;;
                esac
                if ! [ "`grep "${domain[$i]}" /home/core/Mentees/r${inp[0]}/domain_pref.txt`" ]
                then
                    mentor="`cat /home/core/Mentees/r${inp[0]}/.mentor${domain[$i]}`"
                    rm -rf /home/core/Mentors/${domain[$i]}/$mentor/submittedTasks/Task1/${inp[0]} /home/core/Mentors/${domain[$i]}/$mentor/submittedTasks/Task2/${inp[0]} /home/core/Mentors/${domain[$i]}/$mentor/submittedTasks/Task3/${inp[0]}
                    lineno="`grep -n "${inp[0]}" /home/core/Mentors/${domain[$i]}/$mentor/allocatedMentees.txt | cut -f1 -d:`"
                    if [ "$lineno" ]
                    then
                        sed -i "${lineno}d" /home/core/Mentors/${domain[$i]}/$mentor/allocatedMentees.txt
                    fi
                    count=$((count+1))
                fi
            done 
        done <<< ${inp[2]}
        if [ $count -eq 3 ]
        then
            sudo userdel -r r${inp[0]}
            delusers[$dc]="${inp[0]}"
            dc=$((dc+1))
        fi
    fi
    condition=1
done < ~/mentees_domain.txt

for (( i = 0; i < ${#delusers[@]}; i++ ))
do
    lineno="`grep -n "${delusers[$i]}" ~/mentees_domain.txt | cut -f1 -d:`"
    if [ "$lineno" ]
    then
        sed -i "${lineno}d" /home/core/mentees_domain.txt
    fi
done