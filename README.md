# Task 1 : Gemini Club Inductions Server

## Dependencies

Install the dependencies
```sh
sudo apt install zenity acl
```
## Setup
To create `core` user
```sh
bash Task_1/setup.sh
```
> __Note__ : Set password for Mentee and Mentor account before usage by `sudo passwd <username>`

## Aliases
### Core
|Alias|Use|
| ------ | ------ |
| `userGen` | Creates user accounts for Mentors and Mentees |
|`mentorAllocation`| Allocates mentors by First-Come-First-Serve basis|
|`displayStatus`| Display status of submitted tasks and saves list of mentees who submitted the tasks in the `displayStatus.txt`

 >__Usage__ : `displayStatus -a`           -> Print out the total percentage of people who submitted each task with list of mentees who submitted the task since the last time the core used this alias
    `displayStatus --<domain>`   -> To filter the results by domian [web,app,sysad]
### Mentor
|Alias|Use|
| ------ | ------ |
|`submitTask`|Checks whether the submitted task is completed and updates the status in mentee's `task_completed.txt` |
|`setQuiz`|Used to create quiz for mentee|

### Mentee
|Alias|Use|
| ------ | ------ |
|`domainPref`|Creates domain preference order and saves it in `domain_pref.txt` |
|`deRegister`|Used to degister from the domain |
|`submitTask`|To submit task by task number and domain |
> __Note__ : You can also select a file to submit while using `submitTask` alias

### Cronjob for `core` user
- Run `displayStatus` every once a day
- Check every mentee to see if they have deregistered, and if so remove corresponding files. This will run at 10:10 every three days of the week (Monday, Wednesday and Friday) and on Sundays for May, June, and July. This is achieved by `10 10 * 5-7 0,1,3,5`


> __Disclaimer__ : This is my first bash script. Out of curiosity, I wrote it in a less understandable manner. I will improve my scripting style in future tasks.







