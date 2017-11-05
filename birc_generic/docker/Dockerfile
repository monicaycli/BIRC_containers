#mkdir docker_layers && cd docker_layers
#docker build -t birc -f birc_docker .
# docker run -it 908fe7f328f9

FROM ubuntu:xenial
MAINTAINER <rhancock@gmail.com>

# apt installs
## essential packages
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nano curl ed file tcsh git wget \
	build-essential cmake pigz unzip pkg-config s3cmd s3fs \
	bzip2 unzip libxml2-dev libxslt-dev 

## useful packages
#Install a system python (with patched paltform.dist()) here
#Anaconda will be installed later
RUN apt-get install -y parallel imagemagick graphviz xvfb python2.7

# Directories
## binds
RUN mkdir -p /bind/lib/{cuda,atlas,lapack,blas} && \
	mkdir /bind/{data,data_in,data_out,freesurfer,resources} && /bind/scripts && mkdir -p /bind/bin/matlab

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
RUN curl -L -O https://downloads.sourceforge.net/project/tarquin/TARQUIN_4.3.10/TARQUIN_Linux_4.3.10.tar.gz |tar xz && \
	mv TARQUIN_linux* /usr/local/tarquin
ENV PATH "${PATH}:/usr/local/tarquin"

## Gannet
WORKDIR $MFILES
RUN git clone https://github.com/richardedden/Gannet3.0.git
ENV MATLABPATH "${MFILES}/Gannet3.0:$MATLABPATH"


## AFNI
WORKDIR $DOWNLOADS
RUN apt-get install -y gsl-bin netpbm r-base-core && \
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
	mv ${FSL_DIR}bin/eddy_cuda ${FSL_DIR}/bin/eddy_cuda7.0 && \
	ln -s ${FSL_DIR}/bin/eddy_cuda8.0 ${FSL_DIR}/bin/eddy_cuda


## DTIPrep
WORKDIR $DOWNLOADS
RUN curl -O https://www.nitrc.org/frs/download.php/10085/DTIPrepTools-1.2.8-Linux.tar.gz && \
	tar xzf DTIPrepTools-1.2.8-Linux.tar.gz && \
	mv DTIPrep*/bin /usr/local/dtiprep
ENV PATH "${PATH}:/usr/local/dtiprep"


## FreeSurfer
WORKDIR $DOWNLOADS
RUN curl -O ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0-HCP/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz && \
	tar -C /usr/local/ -xzf freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz 

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
WORKDIR $DOWNLOADS
RUN curl -O -L https://sourceforge.net/projects/c3d/files/c3d/Nightly/c3d-nightly-Linux-x86_64.tar.gz |tar xz && \
	mv c3d* /usr/local/c3d
ENV PATH "${PATH}:/usr/local/c3d/bin"

RUN git clone https://github.com/rhr-pruim/ICA-AROMA.git && mv ICA-AROMA /usr/share
ENV PATH "${PATH}:/usr/share/ICA-AROMA"


# Python
## Anaconda 2
RUN curl -O https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh && \
	bash Anaconda2-5.0.1-Linux-x86_64.sh -b -p /usr/local/anaconda2
ENV PATH "/usr/local/anaconda2/bin:${PATH}"

RUN conda create --channel conda-forge -y -n python3 python=3.6 anaconda nibabel pystan nipype
RUN conda create -y -n poldrack python=3.6


## mriqc
RUN source activate poldrack && \
	pip install -r https://raw.githubusercontent.com/poldracklab/mriqc/master/requirements.txt && \
	pip install git+https://github.com/poldracklab/mriqc.git
RUN source deactivate 

## fmriprep
RUN source activate poldrack && \
	pip install fmriprep 
RUN source deactivate 

## cpac
RUN apt-get install -y libgraphviz-dev graphviz 
RUN conda create -y -n cpac2 python=2.7 cython numpy scipy matplotlib networkx==1.11 traits pyyaml jinja2==2.7.2 nose ipython pip wxpython pandas graphviz pydot && \
	source activate cpac && \
	pip install lockfile pygraphviz nibabel nipype patsy psutil boto3 INDI-Tools future==0.15.2 prov simplejson fs==0.5.4
RUN source deactivate

# R
RUN apt-get install -y r-cran-ggplot2

#install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies=TRUE)


# Cleanup
RUN apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
RUN rm -rf $DOWNLOADS

# Configuration

## PREpend user scripts to the path
ENV PATH /bind/scripts:$PATH

## Other ENVs

#setup entry points to run the initialization script
#by default, run the user runtime.sh, but user can override
#e.g. docker run birc myscript.sh
ENTRYPOINT ["/usr/bin/env","/usr/local/bin/entry_init.sh"]
CMD ["/bind/scripts/runtime.sh"]

COPY entry_init.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entry_init.sh
