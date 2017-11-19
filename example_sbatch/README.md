# Example SLURM scripts

## `mk_skel.sh`

Usage: `mk_skel.sh projectname`

Creates a recommended directory skeleton under `/scratch/${USER}/${projectname}`.

## `burc_wrapper.sh`

Usage: `burc_wrapper.sh command [options...]`

Wrapper script for running a container

## `batch_xxx.sh`

Sample SLURM job submission scripts. These scripts define the resources needed, setup environment variables needed by the container and define paths based on the template directory structure to be bound to the container by the `burc_wrapper.sh` script. 

*You will need to modify these scripts in several poorly indicated places.*

Refer to the [SLURM guide](https://wiki.hpc.uconn.edu/index.php/SLURM_Guide) for more information about defining jobs.

`batch_gpu.sh` is an example of running a CUDA-enabled job on a GPU node.

`batch_openmp.sh` is an example of requesting processors on a single node for OpenMP-enabled jobs.


 
