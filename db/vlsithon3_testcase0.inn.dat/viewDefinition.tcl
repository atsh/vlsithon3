if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name fast_libs\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sky130_ff_1.98_0_nldm.lib.gz\
    ${::IMEX::libVar}/mmmc/sky130_ff_1.98_0_nldm.lib.1.gz\
    ${::IMEX::libVar}/mmmc/sky130_ff_1.98_0_nldm.lib.2.gz\
    ${::IMEX::libVar}/mmmc/sky130_scl_9T_phyCells.lib]
create_library_set -name slow_libs\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sky130_ss_1.62_125_nldm.lib.gz\
    ${::IMEX::libVar}/mmmc/sky130_ss_1.62_125_nldm.lib.1.gz\
    ${::IMEX::libVar}/mmmc/sky130_ss_1.62_125_nldm.lib.2.gz\
    ${::IMEX::libVar}/mmmc/sky130_scl_9T_phyCells.lib]
create_library_set -name typical_libs\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sky130_tt_1.8_25_nldm.lib.gz\
    ${::IMEX::libVar}/mmmc/sky130_tt_1.8_25_nldm.lib.1.gz\
    ${::IMEX::libVar}/mmmc/sky130_tt_1.8_25_nldm.lib.2.gz\
    ${::IMEX::libVar}/mmmc/sky130_scl_9T_phyCells.lib]
create_rc_corner -name rctypical\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 25\
   -qx_tech_file ${::IMEX::libVar}/mmmc/rctypical/qrcTechFile
create_delay_corner -name rctypical_fast\
   -library_set fast_libs\
   -rc_corner rctypical
create_delay_corner -name rctypical_typical\
   -library_set typical_libs\
   -rc_corner rctypical
create_delay_corner -name rctypical_slow\
   -library_set slow_libs\
   -rc_corner rctypical
create_constraint_mode -name func_fast\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_fast/func_fast.sdc]
create_constraint_mode -name func_typical\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_typical/func_typical.sdc]
create_constraint_mode -name func_slow\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_slow/func_slow.sdc]
create_analysis_view -name func_slow_125_1v62 -constraint_mode func_slow -delay_corner rctypical_slow -latency_file ${::IMEX::dataVar}/mmmc/views/func_slow_125_1v62/latency.sdc
create_analysis_view -name func_fast_0_1v98 -constraint_mode func_fast -delay_corner rctypical_fast -latency_file ${::IMEX::dataVar}/mmmc/views/func_fast_0_1v98/latency.sdc
create_analysis_view -name func_typical_25_1v8 -constraint_mode func_typical -delay_corner rctypical_typical -latency_file ${::IMEX::dataVar}/mmmc/views/func_typical_25_1v8/latency.sdc
set_analysis_view -setup [list func_slow_125_1v62 func_typical_25_1v8 func_fast_0_1v98] -hold [list func_slow_125_1v62 func_typical_25_1v8 func_fast_0_1v98]
catch {set_interactive_constraint_mode [list func_fast func_typical func_slow] } 
