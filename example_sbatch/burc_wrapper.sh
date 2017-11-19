#!/bin/bash
#Run the container
#Delete any unused bind points below
singularity run  --bind $(dirname `which matlab`)/..:/bind/bin/matlab \
--bind /apps2/matlab:/bind/matlablicense \
--bind ${DIR_DATA}:/bind/data:rw \
--bind ${DIR_DATAIN}:/bind/data_in:ro \
--bind ${DIR_DATAOUT}:/bind/data_out:rw \
--bind ${SUBJECTS_DIR}:/bind/freesurfer:rw \
--bind ${DIR_RESOURCES}:/bind/resources:ro \
--bind ${DIR_SCRATCH}:/bind/scratch:rw \
--bind ${DIR_WORK}:/bind/work:rw \
--bind ${DIR_SCRIPTS}:/bind/scripts:ro \
/scratch/birc_ro/containers/burc.img "$@"

#add this line to limit access to home and /tmp
#--contain --workdir ${DIR_TMP} \
