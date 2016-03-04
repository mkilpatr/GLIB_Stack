#!/bin/bash
################################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /    Vendor: Xilinx
## \   \   \/     Version : 1.12
##  \   \         Application : Virtex-6 FPGA GTX Transceiver Wizard
##  /   /         Filename : implement_synplify_sh.ejava 
## /___/   /\     
## \   \  /  \
##  \___\/\___\
##
##
## implement_synplify.sh script 
## Generated by Xilinx Virtex-6 FPGA GTX Transceiver Wizard
##
##
## (c) Copyright 2009-2011 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
## 
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.

#-----------------------------------------------------------------------------
# Script to synthesize and implement the RTL provided for the GTX wizard
#-----------------------------------------------------------------------------

##---------------------Change CWD to results-------------------------------------

#Clean results directory
#Create results directory
#Change current directory to results
echo "WARNING: Removing existing results directory"
rm -rf results
mkdir results
cp synplify.prj    ./results
cp *.ngc           ./results

##-----------------------------Run Synthesis-------------------------------------

echo "### Running Synplify Pro - "
synplify_pro -batch synplify.prj

cp gtx_top.edf ./results
cd ./results

##-------------------------------Run ngdbuild---------------------------------------

echo 'Running ngdbuild'
ngdbuild -uc ../../example_design/gtx_top.ucf -p xc6vlx130t-ff1156-1 gtx_top.edf gtx_top.ngd

#end run ngdbuild section

##-------------------------------Run map-------------------------------------------

echo 'Running map'
map -p xc6vlx130t-ff1156-1 -o mapped.ncd gtx_top.ngd

##-------------------------------Run par-------------------------------------------

echo 'Running par'
par mapped.ncd routed.ncd

##---------------------------Report par results-------------------------------------

echo 'Running design through bitgen'
bitgen -w routed.ncd

##-------------------------------Trace Report---------------------------------------

echo 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed 

##-------------------------------Run netgen------------------------------------------

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -dir . -tm gtx_top -w routed.ncd routed.vhd

#Change directory to implement

cd ..

