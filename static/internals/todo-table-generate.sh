#!/bin/bash

# Gather information from bash script

IFS=$'\n'
shopt -s extglob

files=($(grep -rsn TODO cellular_raza --exclude-dir target --exclude-dir .venv))
files=( "${files[@]/%:*/}" )

todos=($(grep -rh TODO cellular_raza --exclude-dir target --exclude-dir .venv))
todos=( "${todos[@]/#*([[:blank:]\/\#\-\!<\"])TODO*([[:blank:]])/}" )

lines=($(grep -rshn TODO cellular_raza --exclude-dir target --exclude-dir .venv))
lines=( "${lines[@]/%:*/}" )

# Begin writing to file

file_out='
<table id="todo-table">
    <thead><tr>
        <th>File</th>
        <th>Line</th>
        <th>Todo</th>
    </tr></thead>
    <tbody>
'

for i in ${!files[@]}; do
    file_out+="
<tr>
    <td>${files[$i]}</td>
    <td>${lines[$i]}</td>
    <td>${todos[$i]}</td>
</tr>"
done

file_out+='
    </tbody>
</table>'

echo "$file_out"
