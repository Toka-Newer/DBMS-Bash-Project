#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 

if [[ -e ../../DataBase ]]
then
   . ./DBmenu.sh
else
    mkdir ../../DataBase
    . ./DBmenu.sh
fi