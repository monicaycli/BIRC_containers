#!/bin/bash
#Run the container
#Delete any unused bind points below
#if you have permissions, you can add :ro to the end of bind options
# to restrict writing in the container
singularity run  --bind $(dirname `which matlab`)/..:/bind/bin/matlab \
--bind /apps2/matlab:/bind/matlablicense \
--bind ${DIR_DATA}:/bind/data \
--bind ${DIR_DATAIN}:/bind/data_in \
--bind ${DIR_DATAOUT}:/bind/data_out \
--bind ${SUBJECTS_DIR}:/bind/freesurfer \
--bind ${DIR_RESOURCES}:/bind/resources \
--bind ${DIR_SCRATCH}:/bind/scratch \
--bind ${DIR_WORK}:/bind/work \
--bind ${DIR_SCRIPTS}:/bind/scripts \
/scratch/birc_ro/containers/burc.img "$@"

#add this line to limit access to home and /tmp
#--contain --workdir ${DIR_TMP} \
