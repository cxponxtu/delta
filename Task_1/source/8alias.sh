#!/bin/bash

read -p "Enter no. of questions : " nos
if [[ "$nos" -le 0 ]] 
then
    echo "Enter valid number"
fi    
for (( i = 1; i <= $nos; i++ ))
do 
    read -p "$i question : " tmp
    question="$question$tmp\n"
done
question=${question::-2}
users=()
count=0
while IFS=" " read -ra mentee
do
    users[$count]="${mentee[1]}"
    count=$((count+1))
done < /home/core/Mentors/SysAd/purav/allocatedMentees.txt

for (( i = 0; i < ${#users[@]}; i++ ))
do
    echo -e $question > /home/core/Mentees/r${users[$i]}/.quiz
done
