#!/bin/bash

# Gather information from bash script

IFS=$'\n'
shopt -s extglob

files=($(grep -irsn TODO cellular_raza --exclude-dir target --exclude-dir .venv))
files=( "${files[@]/#cellular_raza\//}" )
files=( "${files[@]/%:*/}" )

todos=($(grep -irh TODO cellular_raza --exclude-dir target --exclude-dir .venv))
todos=( "${todos[@]/#*([[:blank:]\/\#\-\!<\"])TODO*([[:blank:]])/}" )

lines=($(grep -irshn TODO cellular_raza --exclude-dir target --exclude-dir .venv))
lines=( "${lines[@]/%:*/}" )

# Begin writing to file

file_out='
<table id="todo-table" style="width: 100%;">
    <thead><tr>
        <th></th>
        <th>File</th>
        <th>Line</th>
        <th>Todo</th>
    </tr></thead>
    <tbody>
'

for i in ${!files[@]}; do
    file_out+="
<tr>
    <td>$i</td>
    <td><a href='https://github.com/jonaspleyer/cellular_raza/blob/master/${files[$i]}#L${lines[$i]}'>
        ${files[$i]}
    </a></td>
    <td>${lines[$i]}</td>
    <td>${todos[$i]}</td>
</tr>"
done

file_out+='
    </tbody>
</table>'

echo "$file_out"
