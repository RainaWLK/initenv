# basic task flow for ansible
1. research: collect resourses, read files
2. write files for ansible
3. summary



# for ansible-playbook
1. use `become: true` only if needs.

2. print output of each task
3. default hosts is depends on default in inventory, don't assign single machine as host in playbook

## basic structures
variables
tasks:
- prepare stage: copy files, check env
- configure stage: configure setting files
- deploy stage: deploy, restart services
- verify stage: check result or system status, return failed if verify fail

## coding style
- variable name should be snake case with uppercase


## rules
- if needs to copy folder in remote but the folder exists. make sure the folder is empty, if it isn't, list files in folder and ask me.
- what module should be used:
  - bash script: ansible.builtin.shell with multiple line
  ```
    ansible.builtin.shell: |
      set timeout 300
  ```
- don't run ansible here. this machine cannot run ansible
- connection success is one of
  - tcp connection success
  - http connection response 2xx / 4xx
- for download job, default timeout = 5min
- for job which needs to call *.sh, default timeout = 2min