#!/bin/bash
#Make a directory skeleton for BIRC containers
PROJECT=$1
mkdir -p /home/CAM/${USER}/${PROJECT}/{data,data_in,data_out,freesurfer,scratch,scripts,resources,work,matlab}
