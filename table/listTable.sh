#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
echo "listed Tables"
cd ../../DataBase/$db
ls -F | grep -v / | grep -v Meta
cd ../../scripts/table