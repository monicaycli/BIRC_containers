#!/bin/bash
#entrypoint pre-initialization
source /environment
export FSLDIR=/usr/local/fsl

source ${FSLDIR}/etc/fslconf/fsl.sh

export TMPDIR=/tmp
export JOBLIB_TEMP_FOLDER=$TMPDIR
source $FREESURFER_HOME/SetUpFreeSurfer.sh

#matlab
export PATH=/bind/bin/matlab/bin:"$PATH"
export LD_LIBRARY_PATH=/bind/bin/matlab/bin/glnxa64:${LD_LIBRARY_PATH}
export PS1="\u@\h(burc):\W\\$ "
export prompt="[%n@%m(burc):%c]%# "
#cuda
#export PATH=/bind/lib/cuda/bin:"$PATH"
#export LD_LIBRARY_PATH=/bind/lib/cuda/lib64:${LD_LIBRARY_PATH}

#run the user command
exec "$@"
