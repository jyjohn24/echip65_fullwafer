#!/bin/bash

echo  'delete old files for a clean start'

rm -rf work
#rm -rf work_clkGen
# rm -rf work_noParam
#rm -rf work_postPnRV1hvt
#rm -rf work_postPnRV1svt
#rm -rf work_postPnRV2hvt
#rm -rf work_postPnRV5hvt
#rm -rf work_postPnRV5svt
#rm -rf work_postPnRV4hvt

echo 'run modelsim'
if [ $# -gt 0 ]; then
    # found something on the command line
    echo "running $1.do"
    vsim -do "$1".do

else
    # default testbench is verilog_tb
    echo 'running cic_tb.do'
    vsim -do cic3_64x4_tb.do
fi

