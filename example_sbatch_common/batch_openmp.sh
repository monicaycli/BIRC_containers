#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=First.Last@uconn.edu	# Your email address
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --ntasks=1					# Run a single serial task
#SBATCH --cpus-per-task=4           # Number of cores to use
#SBATCH --mem=4096mb				# Memory limit
#SBATCH --time=20:00:00				# Time limit hh:mm:ss
#SBATCH -e error_%A_%a.log				# Standard error
#SBATCH -o output_%A_%a.log				# Standard output
#SBATCH --job-name=MyJob			# Descriptive job name
#SBATCH --partition=serial			# Use a serial partition 24 cores/7days

export OMP_NUM_THREADS=4			#<= cpus-per-task
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4	#<= cpus-per-task
##### END OF JOB DEFINITION  #####

#Define user paths
NETID=$USER
PROJECT=<project name>

# edit this file to customize paths
source sbatch_env.sh

#load any extra modules

#finally call the container with any arguments for the job
#wrapper will bind the appropriate paths
#environment variables are passed to the container

./burc_wrapper.sh <executable path inside the container>
