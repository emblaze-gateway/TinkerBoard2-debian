#!/bin/bash

arr=()
read_lines()
{
        while read line || [ -n "$line" ]; do
                # display $line or do somthing with $line
                line="$(echo $(echo $line | cut -d '#' -f1))"
                if [ ! -z "$line" ]; then
                        arr+=("$line\\")
                fi
        done < "$1"
}
read_lines $1
echo "${arr[@]}"
