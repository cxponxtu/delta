#!/bin/bash

if [ "`groups | grep "mentee"`" ]
then
    echo "Select domain to submit task"
    domain=()
    i=0
    files=()
    tmp="`ls ~ -p | grep -v -e / -e task_submitted.txt -e task_completed.txt -e domain_pref.txt`"
    while read name
    do
        files[$i]=$name
        i=$((i+1))
    done <<< $tmp

    i=0
    while IFS=" " read -ra inp
    do
        domain[$i]="${inp[0]}"
        i=$((i+1))
    done < ~/domain_pref.txt

    select option in ${domain[@]}
    do
        read -p "Enter Task no. : " no
        if [[ $no -lt 4 ]] && [[ $no -gt 0 ]]
        then
            mkdir -p ~/$option/Task$no/
            lineno="`grep -n "${option::-3}" ~/task_submitted.txt | cut -f1 -d:`"
            sed -i "$((lineno+no))d"  ~/task_submitted.txt
            sed -i "$((lineno+no))i --Task$no: y" ~/task_submitted.txt
            sed -i "s/--\(Task*\)/    \1/" ~/task_submitted.txt
            if [ "${files[@]}" ]
            then
                echo "Select file to submit : "
                select file in ${files[@]}
                do
                    cp ~/$file ~/$option/Task$no/
                    break
                done
                break
            fi
            break
        else
            echo "Enter valid no. "
            break
        fi
    done


elif [ "`groups | grep "mentor"`" ]
then 
    if [ "`groups | grep web`" ]
    then mentordom="WebDev"     
    elif [ "`groups | grep app`" ]
    then mentordom="AppDev"
    elif [ "`groups | grep sys`" ]
    then mentordom="SysAd"
    fi

    while IFS=" " read -ra mente
    do
        status=()
        if [ -d /home/core/Mentees/r${mente[1]}/$mentordom ]
        then
            alldir=(`dir /home/core/Mentees/r${mente[1]}/$mentordom`)
            for folders in ${alldir[@]}
            do  
                tasknum="`echo $folders | grep -o '[[:digit:]]*'`"

                if ! [[ -d ~/submittedTasks/$folders/${mente[1]} ]]
                then 
                    ln -s /home/core/Mentees/r${mente[1]}/$mentordom/$folders ~/submittedTasks/$folders/${mente[1]}
                fi 

                if [ "`dir ~/submittedTasks/$folders/${mente[1]}`" ]
                then status[$tasknum]="y"
                fi                  
            done

            for j in {1..3}
            do
                if [ -z ${status[$j]} ]
                then status[$j]="n"
                fi
            done
        
            if [ "`cat /home/core/Mentees/r${mente[1]}/task_completed.txt | grep "${mentordom}"`" ]
            then
                lineno="`grep -n "${mentordom}" /home/core/Mentees/r${mente[1]}/task_completed.txt | cut -f1 -d:`"   
                for (( n = 0; n <= 3; n++ ))
                do
                    sed -i "${lineno}d" /home/core/Mentees/r${mente[1]}/task_completed.txt
                done
            fi
            echo "${mentordom}:
    Task1: ${status[1]}
    Task2: ${status[2]}
    Task3: ${status[3]}" >> /home/core/Mentees/r${mente[1]}/task_completed.txt
        fi      
    done < ~/allocatedMentees.txt
fi
