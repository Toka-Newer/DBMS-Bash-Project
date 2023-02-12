#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
echo "listed Databases"
ls -F ../../DataBase | grep /
