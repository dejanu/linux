
#!/usr/bin/bash


PS3="Alege: "

select var in ls pwd cat less quit
do
case $var in
        ls)             ls
                        ;;
        pwd)            pwd
                        ;;
        cat)            echo -n "Introduceti numele fisierului: "
                        read file
                        if [ -f $file -a -r $file ]
                        then
                                cat $file
                        else
                                echo $file neutilizabil
                        fi
                        ;;
        less)           echo -n "Introduceti numele fisierului: "
                        read file
                        if [[ -f $file && -r $file ]]
                        then
                                less $file
                       else
                                echo $file neutilizabil
                        fi
                        ;;
        quit)           exit 0
                        ;;
        *)              echo Alegere invalida $REPLY
                        ;;
esac
done
