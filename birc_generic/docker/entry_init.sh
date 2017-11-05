#!/bin/bash
#entrypoint pre-initialization
source $FREESURFER_HOME/SetUpFreeSurfer.sh

#TODO: configure this for ANTs
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
#run the user command
exec "$@"
