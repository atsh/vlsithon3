global pathB_loaded
global start_time
global end_time

proc pathB_load {} {
global pathB_loaded
global start_time
global end_time

    if { [info exists pathB_loaded] && $pathB_loaded == 1 } {
        puts "VLSITHON3: pathB already loaded"
        puts "VLSITHON3: pathB debug started at: $start_time"
    } else {
        set start_time [clock seconds]
if {  ![file exists .pathB_time]} {
set fp [open ".pathB_time" w]
puts $fp $start_time
close $fp
}

        load_timing_debug_report \
            -name default_report \
            db/pathB.mrpt

        set pathB_loaded 1
        puts "VLSITHON3: pathB debug started at: $start_time"
	puts "VLSITHON3: pathB loaded. Now open \"Timing -> Debug Timing\" on the menu bar"
    }
}

proc pathB_check {} {
global pathB_loaded
global start_time
global end_time
    if { [info exists pathB_loaded] && $pathB_loaded == 1 } {
	report_timing -from core0/XIDATA_reg[10]/Q  -to core0/REGS_reg[11][24]/SE  -path_type summary
set fp [open ".pathB_time" r]
set start_time [gets $fp]
close $fp
	puts "VLSITHON3: Time spent on pathB: [expr ([clock seconds] - $start_time)/60 ] minutes"
	} else { pathB_load }
}

proc pathB_submit {} {
global pathB_loaded
global start_time
global end_time
    if {[info exists pathB_loaded] && $pathB_loaded == 1} {
	set end_time [clock seconds]
	puts "\n\nVLSITHON3: pathB debug ended at: $end_time\n\n"
set fp [open ".pathB_time" r]
set start_time [gets $fp]
close $fp
	puts "\n\n***VLSITHON3: Time spent on pathB: [expr ($end_time - $start_time)/60 ] minutes***\n\n"
	exit
} else { pathB_load }
}

