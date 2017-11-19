# BIRC User Container for Research (BURC)

BURC provides a large suite of neuroimaging packages for the analysis of functional, structural, and diffusion MRI, MRS and M/EEG data in a container that can be run under Docker or Singularity. Containers are lightweight, self-contained software environments that run on a host system.

# Quick Start on HPC

```
#set up a directory structure
module load git
git clone https://github.com/bircibrain/containers.git
cd containers/example_sbatch
./mk_sel.sh myproject
```

1. Put any data files and scripts in the respective directories under `/scratch/${USER}/myproject`
2. Edit the example SLURM batch scripts (e.g. `batch_openmp.sh` for an OpenMP enabled job)
3. Submit your job using

`sbatch ./batch_openmp.sh`



# Installation

## Host System
### macOS
- Download and install [Docker CE](https://store.docker.com/editions/community/docker-ce-desktop-mac)

### Linux

- Download and install [Singularity](http://singularity.lbl.gov) OR
- Download and install [Docker CE](https://store.docker.com/editions/community/docker-ce-desktop-mac) 

### Storrs HPC

- Singularity (2.3) is installed on Storrs HPC
- Container images are available at `/scratch/birc_ro/containers`


---

# Build the Container

## Docker
To build the container directly from the git repository (`master` branch), run
`docker build -t burc https://github.com/bircibrain/containers.git#master:burc`

## Singularity
You are encouraged to use the prebuilt containers at 

- `/scratch/birc_ro/containers` on HPC



# Run the Container

**Singularity**

`singularity run burc.img /bin/bash`

**Docker**

`docker run -t burc /bin/bash`

The commands above will open an interactive shell session inside the container. In practice, you probably want to bind some host directories to the container and execute a script in place of `/bin/bash`, as described below.


# Usage

## Bind Points

A container filesystem is normally isolated from the host file system. Several *bind points* are defined in the container to aid in connecting your host system files to the container. Examples of creating a host directory structure (`mk_skel.sh`) and binding these (`burc_wrapper.sh`) are provided on [GitHub](https://github.com/bircibrain/containers).

Under Singularity, directories can be bound to the container using multiple `--bind /path/on/host:/path/in/container` options. The path in the container must exist. Some useful bind points inside the container are:

- `/bind/data`, `/bind/data_out` are recommended for attaching read-write directories
- `/bind/data_in`, `/bind/resources` are recommended for attaching read-only directories
- `/bind/scripts` for user scripts and executables. This directory is prepended to the container `PATH`.
- The FreeSurfer `SUBJECTS_DIR` variable points to `/bind/freesurfer` (although this can be changed)
- `/bind/scratch` and `/bind/work` are intended for temporary files, mirroring the architecture of the [Storrs HPC filesystems](https://wiki.hpc.uconn.edu/index.php/Data_Storage_Guide)

## Special Bind Points 

### Matlab

- A host Matlab installation can be attached by binding the base matlab directory (containing `bin` and `bin/glnxa64`) can be attached to `/bind/bin/matlab` 
- Matlab may also require a directory containing a license file to be attached to `/bind/matlablicense` and the `LM_LICENSE_FILE` environment variable set to point to this file

### CUDA

- CUDA 8.0.61 and NVIDIA driver 375.26 (matching Storrs GPU node drivers) are installed in the container
- `/bind/cuda` is also provided for the adventurous user who needs a different configuration


## Running commands

Simply pass a command known to the container (e.g. an executable script in `/bind/scripts`) and any options to the run command:

`singularity run burc.img command [options...]`

`docker run -t burc command [options...]`

Behind the scenes, `command [options...]` are passed as arguments to a bash script that manages environment initialization and then calls 
`exec "$@"`


# Installed software

In general, the current version of each package is pulled when the container is built. Major packages installed include:

## DICOM converters
- `dcm2niix`
- `dicm2nii` (requires Matlab)
- `pydicom`, `nibabel`, `dcmstack`, `bidskit`, `heudiconv`

## Neuroimaging Analysis
- AFNI
- FSL with patched `eddy_cuda`
- Freesurfer 6.0
- ANTs
- DTIPrep

## Spectroscopy

- Tarquin
- Gannet 3.0 master (requires Matlab)

## M/EEG

- Fieldtrip (requires Matlab)

## Neuroimaging Pipelines

- fmriprep
- mriqc
- C-PAC
- nipype

## Statistics

- R
- pystan and Rstan
- MCMCglmm

## Python

There are several versions of python installed:

- A system python 2.7 at `/usr/bin/python`
- Anaconda python 2.7 (`/usr/bin/env python`)
- A python 3.6 Anaconda environment (`python3`)


### Python environments

There are several Anaconda-based environments. Switch between them using `source activate name`

- `python3` Python 3.6 with `nibabel`, `nipype` and `pystan`
- `cpac` (Python 2.7)
- `poldrack` (Python 3.6) with `fmriprep` and `mriqc`


# Bugs/Feature Requests

Submit bug reports and feature requests on [GitHub](https://github.com/bircibrain/containers/issues/)




