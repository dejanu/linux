#!/usr/bin/awk -f
#script takes as argument file e.g /etc/passwd
BEGIN {
        #filed separatpr
        FS=":"
        print "|----------------|--------|--------|--------------------|"
        print "|  USERNAME      |  UID   |  GID   |  HOME DIRECTORY    |"
        print "|----------------|--------|--------|--------------------|"
}

END {

        print "|----------------|--------|--------|--------------------|"
        print "| NO. USERS:  ",NR,"                                 |"
        print "|----------------|--------|--------|--------------------|"
}

{
        if (length($1) > 14 ) {
                $1 = substr($1,0,12)".."
        }
        printf "| %-14.14s | %6d | %6d | %-18.18s |\n",$1,$3,$4,$6
}
