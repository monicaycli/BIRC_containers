#!/bin/bash
#Run the container
#Delete any unused bind points below
#if you have permissions, you can add :ro to the end of bind options
# to restrict writing in the container

export ONXANADU=0

if [ `hostname|grep -E -c "xanadu|shangrila"` -eq 1 ]; then
	export ONXANADU=1
fi

if [ $ONXANADU ]; then
	echo "Running on xanadu"
	MATLABLIC_PATH=${DIR_BASE}/matlab
	IMG_PATH=/home/CAM/${USER}/containers/burc/bin/burc.img
else
	IMG_PATH=/scratch/birc_ro/containers/burc.img
	MATLABLIC_PATH=/apps2/matlab
fi

singularity run  --bind $(dirname `which matlab`)/..:/bind/bin/matlab \
--bind ${MATLABLIC_PATH}:/bind/matlablicense \
--bind ${DIR_DATA}:/bind/data \
--bind ${DIR_DATAIN}:/bind/data_in \
--bind ${DIR_DATAOUT}:/bind/data_out \
--bind ${SUBJECTS_DIR}:/bind/freesurfer \
--bind ${DIR_RESOURCES}:/bind/resources \
--bind ${DIR_SCRATCH}:/bind/scratch \
--bind ${DIR_WORK}:/bind/work \
--bind ${DIR_SCRIPTS}:/bind/scripts \
$IMG_PATH "$@"

#add this line to limit access to home and /tmp
#--contain --workdir ${DIR_TMP} \
