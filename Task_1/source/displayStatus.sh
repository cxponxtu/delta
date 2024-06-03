#!/bin/bash
if [ -f /home/core/.displayStatus_old.txt ]
    then
        rm /home/core/.displayStatus_old.txt
       
    fi
    if [ -f /home/core/displayStatus.txt ]
    then 
        mv /home/core/displayStatus.txt /home/core/.displayStatus_old.txt
    fi

    i=0 wc=0 ac=0 sc=0 ws1=0 as1=0 ss1=0 ws2=0 as2=0 ss2=0 ws3=0 as3=0 ss3=0 t=0
    while IFS=" " read -ra dom
    do
        if [ $i -eq 1 ]
        then
            str=""
            t=$((t+1))
            IFS="->" read -ra dom2 <<< ${dom[2]}
            for (( j = 0; j < ${#dom2[@]}; j+=2 ))
            do
                case ${dom2[$j]} in
                web) 
                    wc=$((wc+1))
                    dir=(`dir /home/core/Mentees/r${dom[0]}/WebDev`) 
                    status=()
                    for folder in ${dir[@]}
                    do
                        case $folder in 
                        Task1) 
                            ws1=$((ws1+1)) 
                            status[1]=1     ;;
                        Task2) 
                            ws2=$((ws2+1)) 
                            status[2]=1     ;;
                        Task3) 
                            ws3=$((ws3+1)) 
                            status[3]=1     ;;
                        esac
                    done 
                    l=0
                    if [ ${#dir[@]} ]
                    then
                        for (( k = 1; k <= 3; k++ ))
                        do 
                            if [[ $l -eq 0 ]] && [[ ${status[k]} ]]
                            then 
                                tc="$k"
                                l=1
                            elif [ $l -eq 1 ] && [[ ${status[k]} ]]
                            then 
                                tc="$tc,$k"
                            fi
                        done
                        str="$str WebDev:$tc"
                    fi ;;
                app) 
                    ac=$((ac+1)) 
                    dir=(`dir /home/core/Mentees/r${dom[0]}/AppDev`) 
                    status=()
                    for folder in ${dir[@]}
                    do
                        case $folder in 
                        Task1) 
                            as1=$((as1+1)) 
                            status[1]=1     ;;
                        Task2) 
                            as2=$((as2+1)) 
                            status[2]=1     ;;
                        Task3) 
                            as3=$((as3+1)) 
                            status[3]=1     ;;
                        esac
                    done 
                    l=0
                    if [ ${dir[@]} ]
                    then
                        echo "hi"
                        for (( k = 1; k <= 3; k++ ))
                        do 
                            if [[ $l -eq 0 ]] && [[ ${status[k]} ]]
                            then 
                                tc="$k"
                                l=1
                            elif [ $l -eq 1 ] && [[ ${status[k]} ]]
                            then 
                                tc="$tc,$k"
                            fi
                        done
                        str="$str AppDev:$tc"
                    fi ;;
                    
                sysad)
                    sc=$((sc+1)) 
                    dir=(`dir /home/core/Mentees/r${dom[0]}/SysAd`)
                    status=()
                    for folder in ${dir[@]}
                    do
                        
                        case $folder in 
                        Task1) 
                            ss1=$((ss1+1)) 
                            status[1]=1    ;;
                        Task2) 
                            ss2=$((ss2+1)) 
                            status[2]=1    ;;
                        Task3) 
                            ss3=$((ss3+1)) 
                            status[3]=1   ;;
                        esac
                    done 
                    l=0
                    if [ ${#dir[@]} ]
                    then
                        for (( k = 1; k <= 3; k++ ))
                        do 
                            if [[ $l -eq 0 ]] && [[ ${status[k]} ]]
                            then 
                                tc="$k"
                                l=1
                            elif [ $l -eq 1 ] && [[ ${status[k]} ]]
                            then 
                                tc="$tc,$k"
                            fi
                        done
                        str="$str SysAd:$tc"
                    fi ;;
                esac
            done
            echo "${dom[0]}$str" >> /home/core/displayStatus.txt
            chmod 700 /home/core/displayStatus.txt
        fi
        i=1
    done < /home/core/mentees_domain.txt

    if [ $wc -ne 0 ]
    then
        webtask1percent=$((ws1/wc*100))
        webtask2percent=$((ws2/wc*100))
        webtask3percent=$((ws3/wc*100))
    fi
    if [ $ac -ne 0 ]
    then
        apptask1percent=$((as1/ac*100))
        apptask2percent=$((as2/ac*100))
        apptask3percent=$((as3/ac*100))
    fi
    if [ $sc -ne 0 ]
    then
        systask1percent=$((ss1/sc*100))
        systask2percent=$((ss2/sc*100))
        systask3percent=$((ss3/sc*100))
    fi

    newsubmissions=""
    oldstat=0
    if [ -f /home/core/.displayStatus_old.txt ]
    then
        oldstat=1
        while read -r line
        do
                if ! [ "`grep "$line" /home/core/.displayStatus_old.txt`" ]
                then
                    newsubmissions="$newsubmissions$line \n"
                fi
        done < /home/core/displayStatus.txt
    else 
        while read -r line
        do
            newsubmissions="$newsubmissions$line \n"
        done < /home/core/displayStatus.txt
    fi

    if [ "$newsubmissions" ]
    then
        newsubmissions=${newsubmissions::-2}
    fi

            echo "
                WebDev
            Task 1 -> $webtask1percent %
            Task 2 -> $webtask2percent %
            Task 3 -> $webtask3percent %
                AppDev
            Task 1 -> $apptask1percent %
            Task 2 -> $apptask2percent %
            Task 3 -> $apptask3percent %
                SysAd
            Task 1 -> $systask1percent %
            Task 2 -> $systask2percent %
            Task 3 -> $systask3percent %
            New Submissions 
            ` while IFS=" " read -ra prnttxt
            do
                echo -e "\t${prnttxt[@]}"
            done <<< $newsubmissions` " > ~/Task_NewSubmissions.txt
            chmod 700 ~/Task_NewSubmissions.txt
