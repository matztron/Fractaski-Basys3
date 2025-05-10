#!/bin/tclsh

## FPGA part number
#set FPGA_PART "xc7a100tcsg324-1"

#set_param ips.validateJSONSchemaRead 0 
#set_param ips.validateJSONSchemaWrite 0
# Assign from global variables
set selected_fpga_part  $env(FPGA_PART)
set COMPILE_SCRIPTS_DIR $env(COMPILE_SCRIPTS_DIR)
set TOP_RTL             $env(TOP_RTL)

set MMCM_OUT_FREQ_MHZ $env(MMCM_OUT_FREQ_MHZ)
set NUM_PIPE_STAGES $env(NUM_PIPE_STAGES)
set NUM_THREADS $env(NUM_THREADS)
set ENABLE_BRAM_REGFILE $env(ENABLE_BRAM_REGFILE)
set ENABLE_ALU_DSP $env(ENABLE_ALU_DSP)
set ENABLE_UNIFIED_BARREL_SHIFTER $env(ENABLE_UNIFIED_BARREL_SHIFTER)
set SINGLE_PROGRAM $env(SINGLE_PROGRAM)
set CORE_HARD_BARRIER $env(CORE_HARD_BARRIER)
set HEX_PROG $env(HEX_PROG)

# Print the variables
puts "MMCM_OUT_FREQ_MHZ: $MMCM_OUT_FREQ_MHZ"
puts "NUM_PIPE_STAGES: $NUM_PIPE_STAGES"
puts "NUM_THREADS: $NUM_THREADS"
puts "ENABLE_BRAM_REGFILE: $ENABLE_BRAM_REGFILE"
puts "ENABLE_ALU_DSP: $ENABLE_ALU_DSP"
puts "ENABLE_UNIFIED_BARREL_SHIFTER: $ENABLE_UNIFIED_BARREL_SHIFTER"
puts "SINGLE_PROGRAM: $SINGLE_PROGRAM"
puts "CORE_HARD_BARRIER: $CORE_HARD_BARRIER"
puts "HEX_PROG: $HEX_PROG"

#TBD basys3 and nx-video fpga_parts
set fpga_parts [dict create \
    "nexys-a7"   "xc7a100tcsg324-1"\
    "basys3" "xcb"\
    "nexys-video" "xnv"\
    ]

set FPGA_PART [dict get $fpga_parts $selected_fpga_part]

set INC_DIR               "../../../submodules/BRISKI/hardware/vivado-impl/utils"
set RTL_SOURCE_DIR        "../../rtl"
set RISCV_CORE_SOURCE_DIR "../../../submodules/BRISKI/hardware/rtl"
set USR_CONSTR_DIR        "../usr-constraints"
set outputDir ../$env(RUN_DIR)

set_part $FPGA_PART

set time1 [clock seconds]
#=====================================================#
#          ------------ READ SOURCES -----------------#
#=====================================================#
source $COMPILE_SCRIPTS_DIR/read_sources.tcl

#=====================================================#
#          ------------ SYNTHESIS --------------------#
#=====================================================#
source $COMPILE_SCRIPTS_DIR/synth.tcl
#=====================================================#
#          ------------ OPT --------------------------#
#=====================================================#
source $COMPILE_SCRIPTS_DIR/opt.tcl
#=====================================================#
#          ------------ PLACE ------------------------#
#=====================================================#
source $COMPILE_SCRIPTS_DIR/place.tcl
##--------------post place phys_opt--------------------#
source $COMPILE_SCRIPTS_DIR/post_place_physopt.tcl
##=====================================================#
##          ------------ ROUTE ------------------------#
##=====================================================#
source $COMPILE_SCRIPTS_DIR/route.tcl
source $COMPILE_SCRIPTS_DIR/route_critical_first.tcl
##--------------post route phys_opt--------------------#
source $COMPILE_SCRIPTS_DIR/post_route.tcl
##=====================================================#
##          ------------ BITSTREAM --------------------#
##=====================================================#
source $COMPILE_SCRIPTS_DIR/bitstream.tcl

set time2 [clock seconds]
puts "Total Compilation time (TOTAL)= [expr [expr $time2 - $time1] / 3600] Hours : [expr [expr [expr $time2 - $time1] / 60] % 60] Minutes : [expr [expr $time2 - $time1] % 60] Seconds"

