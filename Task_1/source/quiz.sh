#!/bin/bash

if [ -f ~/.quiz ]
then
    zenity --question --title="Question : $i" --text="New Quiz! Do you want to answer? "
    if [ $? -eq 0 ]
    then
        if [ -f ~/quiz_answers.txt ]
        then
            rm ~/quiz_answers.txt
        fi
        questions=()
        count=1

        while read input
        do  
            questions[$count]="$input"
            count=$((count+1))
        done < ~/.quiz

        for(( i = 1; i <= ${#questions[@]}; i++ ))
        do
            echo "$i) `zenity --forms --title="Question" \
                --text="${questions[$i]}" \
                --add-entry="Answer"`" >> ~/quiz_answers.txt 
        done
        rm -f ~/.quiz
    fi
fi
