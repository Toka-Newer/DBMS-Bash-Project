#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
echo "listed Tables"
ls -F ../../DataBase/$db | grep -v / | grep -v Meta
