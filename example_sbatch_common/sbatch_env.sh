#!/bin/bash
export ONXANADU=0
  if [ `hostname|grep -E -c "shangrila|xanadu"` ]; then
  export ONXANADU=1
fi

if [ $ONXANADU ]; then
  export DIR_BASE=/home/CAM/${NETID}/projects/${PROJECT}
  export DIR_WORK=${DIR_BASE}/work
  # Load modules
  module load matlab/R2017b				#matlab binaries are bound
  module load singularity/2.4.2
else
  export DIR_BASE=/scratch/${NETID}/${PROJECT}
  export DIR_WORK=/work							#rw /work on HPC is 40Gb local storage
  # Load modules
  module load matlab/2017a				#matlab binaries are bound
  module load singularity/2.3.1-gcc		#required to run the container

  #set the matlab license path to the path inside the container
  export LM_LICENSE_FILE=/bind/matlablicense/uits.lic

fi


export DIR_RESOURCES=${DIR_BASE}/resources 	#ro
export DIR_DATA=${DIR_BASE}/data 				#rw data
export DIR_DATAIN=${DIR_BASE}/data_in			#ro data
export DIR_DATAOUT=${DIR_BASE}/data_out		#rw data
export SUBJECTS_DIR=${DIR_BASE}/freesurfer		#rw for Freesurfer
export DIR_SCRATCH=${DIR_BASE}/scratch 		#rw shared storage
export DIR_SCRIPTS=${DIR_BASE}/scripts 		#ro, prepended to PATH


load module parallel
