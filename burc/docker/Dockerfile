FROM ubuntu:xenial
MAINTAINER <rhancock@gmail.com>

# apt installs
## essential packages
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nano curl ed file tcsh git wget \
	build-essential cmake pigz unzip pkg-config s3cmd s3fs \
	bzip2 unzip libxml2-dev libxslt-dev bc 

#blas and lapack are only availble as static builds-container software will rely on these
#Install the MPICH2 reference MPI implementation inside the container for builds
#These need to be swapped out at runtime on HPC to get system specific interconnect fabric/storage support (GPFS, InfiniBand, CRAY, etc)
RUN apt-get install -y libblas-dev liblapack-dev mpich libmpich-dev libhdf5-mpich-dev

## useful packages
#Install a system python (with patched paltform.dist()) here
#Anaconda will be installed later
RUN apt-get install -y parallel imagemagick graphviz xvfb python2.7

# Directories
## binds
RUN mkdir -p /bind/lib/cuda && \
	mkdir /bind/data && mkdir /bind/data_in && mkdir /bind/data_out && \
	mkdir /bind/freesurfer && mkdir /bind/resources && \
	mkdir /bind/scratch && mkdir /bind/work && \
	mkdir /bind/archive && mkdir /bind/scripts && \
	mkdir -p /bind/bin/matlab && mkdir /bind/matlablicense && \
	mkdir -p /bind/lib/mpich2 && mkdir -p /bind/lib/openmpi && \
	mkdir -p /bind/lib/storage && mkdir -p /bind/lib/fabric

## 
ENV DOWNLOADS /tmp/downloads
RUN mkdir $DOWNLOADS
RUN mkdir /usr/local/share/matlab
ENV MFILES "/usr/local/share/matlab"


# Software

## glob for matlab
WORKDIR $DOWNLOADS
RUN curl -O https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40149/versions/1/download/zip/glob.zip && \
	unzip glob.zip && \
	mv glob.m $MFILES


## dcm2niix
WORKDIR $DOWNLOADS
RUN git clone https://github.com/rordenlab/dcm2niix.git && \
    	cd dcm2niix && mkdir build && cd build && \
        cmake -DBATCH_VERSION=ON -DUSE_OPENJPEG=ON .. && \
        make && make install


## Tarquin
RUN curl -L -O https://downloads.sourceforge.net/project/tarquin/TARQUIN_4.3.10/TARQUIN_Linux_4.3.10.tar.gz && \
	tar xzf  TARQUIN_Linux_4.3.10.tar.gz && \
	mv TARQUIN_Linux_4.3.10 /usr/local/tarquin
ENV PATH "${PATH}:/usr/local/tarquin"

## Gannet
WORKDIR $MFILES
RUN git clone https://github.com/richardedden/Gannet3.0.git
ENV MATLABPATH "${MFILES}/Gannet3.0:$MATLABPATH"


## AFNI
WORKDIR $DOWNLOADS
RUN apt-get install -y gsl-bin netpbm r-base-core libnlopt-dev \
libjpeg62 xvfb libglu1-mesa-dev libglw1-mesa libxm4 libnlopt0 && \
	curl -O https://afni.nimh.nih.gov/pub/dist/bin/linux_ubuntu_16_64/@update.afni.binaries && \
	tcsh @update.afni.binaries -package linux_ubuntu_16_64  \
	-do_extras -bindir /usr/local/afni
ENV PATH /usr/local/afni:${PATH}
RUN curl https://afni.nimh.nih.gov/pub/dist/src/scripts_src/@add_rcran_ubuntu.tcsh |tcsh && \
	rPkgsInstall -pkgs ALL

## FSL
WORKDIR $DOWNLOADS
ENV FSL_DIR /usr/local/fsl

RUN curl -O https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
	chmod 755 fslinstaller.py && \
	./fslinstaller.py -d ${FSL_DIR} -q 

ENV MATLABPATH "${FSL_DIR}/etc/matlab/:${MATLABPATH}"

RUN curl -O https://fsl.fmrib.ox.ac.uk/fsldownloads/patches/eddy-patch-fsl-5.0.11/centos6/eddy_cuda8.0 && \ 
	chmod 755 eddy_cuda8.0 && \
	mv eddy_cuda8.0 ${FSL_DIR}/bin && \
	mv ${FSL_DIR}/bin/eddy_cuda ${FSL_DIR}/bin/eddy_cuda7.0 && \
	ln -s ${FSL_DIR}/bin/eddy_cuda8.0 ${FSL_DIR}/bin/eddy_cuda


## DTIPrep
WORKDIR $DOWNLOADS
RUN curl -O https://www.nitrc.org/frs/download.php/10085/DTIPrepTools-1.2.8-Linux.tar.gz && \
	tar xzf DTIPrepTools-1.2.8-Linux.tar.gz && \
	mv DTIPrep*/bin /usr/local/dtiprep
ENV PATH "${PATH}:/usr/local/dtiprep"


## FreeSurfer
WORKDIR $DOWNLOADS
RUN curl -O ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
	tar -C /usr/local/ -xzf freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz

ENV FREESURFER_HOME /usr/local/freesurfer
ENV SUBJECTS_DIR /bind/freesurfer

### Matlab config for FSFAST
RUN echo "fsfasthome = getenv('FSFAST_HOME');" >> ${MFILES}/startup.m && \
	echo "fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);" >> ${MFILES}/startup.m && \
	echo "path(path,fsfasttoolbox);" >> ${MFILES}/startup.m


## ANTs
WORKDIR $DOWNLOADS
RUN git clone https://github.com/stnava/ANTs.git && \
	mkdir /usr/local/ants && mkdir ANTs/build && \
	cd ANTs/build && cmake .. && make && \
	mv bin /usr/local/ants && mv lib /usr/local/ants
ENV ANTSPATH /usr/local/ants/bin/
ENV PATH "${PATH}:${ANTSPATH}"

## dicm2nii
RUN mkdir ${MFILES}/dicm2nii
WORKDIR ${MFILES}/dicm2nii
RUN curl -O https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/42997/versions/85/download/zip/dicm2nii.zip && \
	unzip dicm2nii.zip && rm dicm2nii.zip
ENV MATLABPATH "${MFILES}/dicm2nii:${MATLABPATH}"




## Fieldtrip
WORKDIR $MFILES
RUN git clone https://github.com/fieldtrip/fieldtrip.git
ENV MATLABPATH "${MFILES}/fieldtrip:${MATLABPATH}"

## fmriprep dependencies
#TODO cleanup hardcoding versions
# pipe to tar/gunzip seems to fail
WORKDIR $DOWNLOADS
RUN curl -O -L https://sourceforge.net/projects/c3d/files/c3d/Nightly/c3d-nightly-Linux-x86_64.tar.gz \
	&& tar xzf c3d-nightly-Linux-x86_64.tar.gz && \
	mv c3d-1.1.0-Linux-x86_64 /usr/local/c3d
ENV PATH "${PATH}:/usr/local/c3d/bin"

RUN git clone https://github.com/rhr-pruim/ICA-AROMA.git && mv ICA-AROMA /usr/share
ENV PATH "${PATH}:/usr/share/ICA-AROMA"


# Python
## Anaconda 2
WORKDIR $DOWNLOADS
RUN curl -O https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh && \
	bash Anaconda2-5.0.1-Linux-x86_64.sh -b -p /usr/local/anaconda2
ENV PATH "/usr/local/anaconda2/bin:${PATH}"

### DICOM tools
RUN conda install --channel conda-forge -y nibabel pystan nipype pydicom
RUN pip install git+https://github.com/moloney/dcmstack.git
RUN pip install https://github.com/nipy/heudiconv/archive/master.zip

RUN git clone https://github.com/jmtyszka/bidskit.git && mv bidskit /usr/local/
ENV PATH "${PATH}":/usr/local/bidskit

RUN conda create --channel conda-forge -y -n python3 python=3.6 anaconda nibabel pystan nipype pydicom 
RUN conda create -y -n poldrack python=3.6

## mriqc
SHELL ["/bin/bash", "-c"]

RUN source activate poldrack && \
	pip install -r https://raw.githubusercontent.com/poldracklab/mriqc/master/requirements.txt && \
	pip install git+https://github.com/poldracklab/mriqc.git
RUN source deactivate 

## fmriprep
RUN source activate poldrack && \
	pip install fmriprep pydicom
RUN source deactivate 

## cpac
RUN apt-get install -y libgraphviz-dev graphviz 
RUN conda create -y -n cpac python=2.7 cython numpy scipy matplotlib networkx==1.11 traits pyyaml jinja2==2.7.2 nose ipython pip wxpython pandas graphviz pydot && \
	source activate cpac && \
	pip install lockfile pygraphviz nibabel nipype patsy psutil boto3 INDI-Tools future==0.15.2 prov simplejson fs==0.5.4
#RUN source deactivate

# R
RUN apt-get install -y r-cran-ggplot2

RUN Rscript -e 'install.packages(c("rstan", "MCMCglmm","mcmc", "MasterBayes"), repos = "https://cloud.r-project.org/", dependencies=TRUE)'

# CUDA
WORKDIR $DOWNLOADS
RUN apt-get install kmod module-init-tools

RUN curl -L -O http://us.download.nvidia.com/XFree86/Linux-x86_64/375.26/NVIDIA-Linux-x86_64-375.26.run && \
	chmod 755 NVIDIA-Linux-x86_64-375.26.run && \
	./NVIDIA-Linux-x86_64-375.26.run -x --target /usr/local/nvidia
ENV PATH /usr/local/nvidia:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia:${LD_LIBRARY_PATH}

#CUDA URLs
#http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
RUN curl -L -O https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run && \
	chmod 755 cuda_8.0.61_375.26_linux-run && \
	./cuda_8.0.61_375.26_linux-run --silent --toolkit
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# AWSCLI
RUN conda install -y -c conda-forge awscli

# VESPA
RUN apt-get install -y fftw3 libfftw3-dev && \
conda create -y -n vespa -c conda-forge python=2.7 numpy scipy matplotlib==1.5.3 wxPython=3.0 packaging pydicom==0.9.9 && \
source activate vespa && \
conda install -y -c https://conda.anaconda.org/dgursoy pywavelets=0.3.0 && \
pip install pygamma hlsvdpro vespa-suite

# GIfTI/CIfTI
#WORKDIR $DOWNLOADS
#RUN curl -L -O http://www.artefact.tk/software/matlab/gifti/gifti-1.6.zip &&\
#unzip gifti-1.6.zip && \
#mv gifti-1.6 ${MFILES}
#ENV MATLABPATH "${MFILES}/gifti-1.6:${MATLABPATH}"

RUN apt-get install -y r-cran-rgl
RUN Rscript -e "install.packages('cifti',repos = 'https://cloud.r-project.org/', dependencies=TRUE)"

# HCP Workbench
WORKDIR $DOWNLOADS
RUN curl -L -O https://ftp.humanconnectome.org/workbench/workbench-linux64-v1.2.3.zip && \
	unzip workbench-linux64-v1.2.3.zip && \
	mv workbench /usr/local
ENV PATH "/usr/local/workbench/bin_linux64:${PATH}"
#ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/workbench/libs_linux64"

# MNE
WORKDIR $DOWNLOADS
RUN curl -O http://birc-int.psy.uconn.edu/containers/deps/MNE-2.7.0-3106-Linux-x86_64.tar.gz && \
	tar xzf MNE-2.7.0-3106-Linux-x86_64.tar.gz && \
	mv MNE-2.7.0-3106-Linux-x86_64 /usr/local/MNE
ENV PATH "${PATH}:/usr/local/MNE/bin"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/MNE/lib"

# Solar
WORKDIR $DOWNLOADS
RUN curl -L -O https://www.nitrc.org/frs/download.php/10455/solar832.zip && \
unzip solar832.zip && \
cd solar832 && chmod 755 install_solar && \
./install_solar /usr/local/solar/8.3.2 /usr/local/bin solar

RUN Rscript -e "install.packages('solarius',repos = 'https://cloud.r-project.org/', dependencies=TRUE)"


# Cleanup
RUN apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
RUN rm -rf $DOWNLOADS
RUN ldconfig

# Configuration

## PREpend user scripts to the path
ENV PATH /bind/scripts:$PATH

## Other ENVs

#setup singularity compatible entry points to run the initialization script
#by default, run the user runtime.sh, but user can override
#e.g. docker run birc myscript.sh
ENTRYPOINT ["/usr/bin/env","/singularity"]
#not singularity compatible
#CMD ["/bind/scripts/runtime.sh"]

COPY entry_init.sh /singularity
COPY freesurfer_license.txt ${FREESURFER_HOME}/license.txt
RUN chmod 755 /singularity

RUN /usr/bin/env |sed  '/^HOME/d' | sed '/^HOSTNAME/d' | sed  '/^USER/d' | sed '/^PWD/d' > /environment && \
	chmod 755 /environment

RUN echo "/usr/local/nvidia" > /etc/ld.so.conf.d/nvidia-lib64.conf && \
ldconfig

RUN echo "Welcome to the BURC!\nDocumentation is available at \n*http://birc-int.psy.uconn.edu/wiki/Containers\n*https://github.com/bircibrain/containers" > /etc/motd


#locale
#RUN apt-get install -y apt-utils locales
#RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale
#RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8


# tcsh/csh  prompt
RUN cat /etc/csh.cshrc | sed -e 's/prompt.*/prompt = "[%n@%m(burc):%c]%# "/' > /tmp/tmp.cshrc && \
mv /tmp/tmp.cshrc /etc/csh.cshrc

# bash prompt
RUN cat /etc/bash.bashrc | sed -e "s/PS1=.*/PS1='\${debian_chroot:+(\$debian_chroot)}\\\u@\\\h(burc):\\\w\\\\$ '/" > /tmp/tmp.bashrc && \
mv /tmp/tmp.bashrc /etc/bash.bashrc


