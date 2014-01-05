#!/bin/bash

#The scripts aim to create CRU dataset from the mask file obtained from Maurer's dataset.

#fn1 is one dataset from Maurer's, fn2 is the mask file made according to one of Maurer's dataset;fn3 is the mask file by averaging variables over time; fn4 is the CRU dataset in a global scale; fn5 is the dataset clipped from global dataset by setting the range of latitude and longitude; fn6 is the final dataset by working on clipped dataset and mask file from Maurer dataset. 

idir=/raid2/homefc/conus/data.sets/Maurer
odir=/raid3/jiawei/homero/cru/mask/Prec
idir2=/raid2/homefc/conus/data.sets/CRU
fn1=`printf "gridded_obs.monthly.Prcp.1991.nc"`
fn2=`printf "test.nc"`
fn3=`printf "mask_pre.nc"`
fn4=`printf "cru_ts3.21.1901.2012.pre.dat.nc"`
fn5=`printf "cru_ts3.21.1901.2012.pre.clip.nc"`
fn6=`printf "cru_ts3.21.1901.2012.pre.mask.nc"`

#clip parts of global map
#I don't know why the range of lat,lon in the final dataset doesn't match the number as shown below. 
ncks -d lat,25.1875,52.8125 -d lon,-124.688,-67.0625 $idir2/$fn4 $odir/$fn5

#remap the grid of Maurer
cdo remapcon,$odir/$fn5 $idir/$fn1 $odir/$fn1

#create a mask file according to one of Maurer's dataset
cdo gtc,0.0 $odir/$fn1 $odir/$fn2

#Average precipitation of mask file over time 
ncwa -O -v Prcp -a time $odir/$fn2 $odir/$fn3

#create a dataset of CRU based on the mask file of Maurer's
cdo ifthen $odir/$fn3 $odir/$fn5 $odir/$fn6

