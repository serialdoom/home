#!/usr/bin/env bash

function ash {
    local host_var_file="host_vars/$1/public.yml"
    local docker_id=$(echo "$1" | cut -c1-12)
    local user=$(whoami)
    [ -f ~/.ash-username ] && user=$(cat ~/.ash-username)
    [[ $VERBOSE ]] && echo "searching $host_var_file"
    if [[ -f $host_var_file ]]; then
        [[ $VERBOSE ]] && echo "Searching in $host_var_file"
        local ip=$(grep "ansible_ssh_host" $host_var_file | cut -d ' ' -f2 | tr -d '"')
        if [[ ! $ip ]]; then
            echo "Error, could not find ip in host_vars folder"
            return 1
        fi
    elif [[ "$(docker ps | grep $docker_id -c)" -eq 1 ]]; then
        local ip=$( docker inspect $docker_id | grep "\"IPAddress\"" | tr -s ' ' | cut -d ' ' -f3 | tr -d "\",")
        local user=root
    fi
    [[ $VERBOSE ]] && echo "cmd [ssh $ip -l $user]"
    ssh $ip -l $user
}

function light {
    echo "$1" | sudo tee /sys/class/backlight/acpi_video0/brightness
}

ash $@
