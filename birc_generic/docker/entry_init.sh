#!/bin/bash
#entrypoint pre-initialization
source /environment
source $FREESURFER_HOME/SetUpFreeSurfer.sh

#matlab
export PATH=/bind/bin/matlab/bin:"$PATH"
export LD_LIBRARY_PATH=/bind/bin/matlab/bin/glnxa64:${LD_LIBRARY_PATH}

#cuda
#export PATH=/bind/lib/cuda/bin:"$PATH"
#export LD_LIBRARY_PATH=/bind/lib/cuda/lib64:${LD_LIBRARY_PATH}

#run the user command
exec "$@"
