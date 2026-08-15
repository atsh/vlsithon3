global pathA_loaded
global start_time
global end_time

proc pathA_load {} {
global pathA_loaded
global start_time
global end_time

    if { [info exists pathA_loaded] && $pathA_loaded == 1 } {
        puts "VLSITHON3: pathA already loaded"
        puts "VLSITHON3: pathA debug started at: $start_time"
    } else {
        set start_time [clock seconds]
if {  ![file exists .pathA_time]} {
set fp [open ".pathA_time" w]
puts $fp $start_time
close $fp
}

        load_timing_debug_report \
            -name default_report \
            db/pathA.mrpt

        set pathA_loaded 1
        puts "VLSITHON3: pathA debug started at: $start_time"
	puts "VLSITHON3: pathA loaded. Now open \"Timing -> Debug Timing\" on the menu bar"
    }
}

proc pathA_check {} {
global pathA_loaded
global start_time
global end_time
    if { [info exists pathA_loaded] && $pathA_loaded == 1 } {
	report_timing -from core0/XIDATA_reg[13]/Q  -to core0/REGS_reg[3][18]/D -path_type summary
set fp [open ".pathA_time" r]
set start_time [gets $fp]
close $fp
	puts "VLSITHON3: Time spent on pathA: [expr ([clock seconds] - $start_time)/60 ] minutes"
	} else { pathA_load }
}


proc pathA_submit {} {
global pathA_loaded
global start_time
global end_time
    if {[info exists pathA_loaded] && $pathA_loaded == 1} {
	set end_time [clock seconds]
	puts "\n\nVLSITHON3: pathA debug ended at: $end_time\n\n"
set fp [open ".pathA_time" r]
set start_time [gets $fp]
close $fp
	puts "\n\n***VLSITHON3: Time spent on pathA: [expr ($end_time - $start_time)/60 ] minutes***\n\n"
	exit
} else { pathA_load }
}

