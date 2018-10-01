#!/bin/bash

echo $(ps -u $(whoami))

function userinfo
{
        echo $(whoami)
        echo $(cat /proc/version)
}
userinfo
####################################

function asib
{
        a=100
        declare b=500
        echo a este $a si b este $b
}
a=10
b=40
asib
echo $b
export $b
####################################

#cat timp nr de param $# este mai mare ca zero
while [[ $# -gt 0 ]]
do
        echo $1
        #elimina parametrii din lista de param  $@
        shift
done
#########################################
for var in "$@"
do
        echo $var
done
echo lista este $@
#########################################
echo Primul Parametru pozitional este $1
echo Al doilea paramentru pozitional este $2
echo Numele scriptului este $0

echo "Scriptul a rulat cu $# paramentrii"
echo Acestia sint $@

