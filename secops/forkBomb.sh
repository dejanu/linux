#!/bin/bash

## fork bomb:  bash function executed recursively $ :(){ :|:& };:
# where : is the name of the function, the function does not take any arguments
# inside the body the function will call itself, and it will pipe the output to another call of the function
# & puts the call in the background so the child cannot die at all and start eating system resources

#################
# bomb() { 
#  bomb | bomb &
# }; bomb

########### Python fork bomb
#import os
#  while(1):
#      os.fork()

# prevent fork bomb by limiting user processes # vi /etc/security/limits.conf

#########################################################################################

## kill all SSH connections
# while true; do killall bash; sleep 1; done
