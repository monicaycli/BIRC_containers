# Containers on macOS
Download and install [Docker CE](https://store.docker.com/editions/community/docker-ce-desktop-mac)

---

# Containers on Linux

- Download and install [Docker CE](https://store.docker.com/editions/community/docker-ce-desktop-mac) OR
- Download and install [Singularity](http://singularity.lbl.gov)

---

# Containers on HPC

- Singularity (2.3) is installed on Storrs HPC
- Docker typically isn't available on HPC for security reasons

---

# Build the Container

---

# Initialization and Endpoints

The default entrypoint executes the following

1. An internal initialization bash script
2. If it exists, `/bind/scripts/entry_init.sh` will be sourced from bash
3. If it exists, `/bind/scripts/runtime.sh` will be execed
4. The final exec of `/bind/scripts/runtime.sh` can be overridden by passing an alternative as an argument, e.g. `docker run birc myscript.sh`

---
# Initialization and Endpoints

The user script directory (`/bind/scripts`) is prepended to the path.

---

# Bind points
Some Singularity configurations and Docker will allow arbitrary overlays or mounts, however the following points will always be available:

- `/bind/data`, `/bind/data_out` are recommended for attaching read-write directories
- `/bind/data_in`, `/bind/resources` are recommended for attaching read-only directories


---

# Bind points
Some Singularity configurations and Docker will allow arbitrary overlays or mounts, however the following points will always be available:

- `/bind/freesurfer` is recommended for read-write when using FreeSurfer. The `SUBJECTS_DIR` environment variable is preset to this.
- `/bind/scripts` special directory for user executables

---

# Special bind points

Some system libraries can be exposed to the container through bind points:

- `/bind/lib/{atlas,blas,lapack}`
 - Versions of these libraries also exist in the container. The container initialization will setup the container to use the bound versions if they are attached. 
- `/bind/lib/cuda`
- `/bind/bin/matlab`

---

# Python

There are several versions of python installed:

- A system python 2.7 at `/usr/bin/python`
- Anaconda python 2.7 (`/usr/bin/env python`)

---

# Python environments

There are several Anaconda-based environments. Switch between them using `source activate name`

- `python3` Python 3.6 with `nibabel`, `nipype` and `pystan`
- `cpac` (Python 2.7)
- `poldrack` (Python 3.6) with `fmriprep` and `mriqc`






