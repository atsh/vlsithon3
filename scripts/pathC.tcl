global pathC_loaded
global start_time
global end_time

proc pathC_load {} {
global pathC_loaded
global start_time
global end_time

    if { [info exists pathC_loaded] && $pathC_loaded == 1 } {
        puts "VLSITHON3: pathC already loaded"
        puts "VLSITHON3: pathC debug started at: $start_time"
    } else {
        set start_time [clock seconds]
if {  ![file exists .pathC_time]} {
set fp [open ".pathC_time" w]
puts $fp $start_time
close $fp
}

        load_timing_debug_report \
            -name default_report \
            db/path3.mrpt

        set pathC_loaded 1
        puts "VLSITHON3: pathC debug started at: $start_time"
	puts "VLSITHON3: pathC loaded. Now open \"Timing -> Debug Timing\" on the menu bar"
    }
}

proc pathC_check {} {
global pathC_loaded
global start_time
global end_time
    if { [info exists pathC_loaded] && $pathC_loaded == 1 } {
	report_timing -from core0/FLUSH_reg[0]/Q  -to core0/XIDATA_reg[16]/D  -path_type summary
set fp [open ".pathC_time" r]
set start_time [gets $fp]
close $fp
	puts "VLSITHON3: Time spent on pathC: [expr ([clock seconds] - $start_time)/60 ] minutes"
	} else { pathC_load }
}


proc pathC_submit {} {
global pathC_loaded
global start_time
global end_time
    if {[info exists pathC_loaded] && $pathC_loaded == 1} {
	set end_time [clock seconds]
	puts "\n\nVLSITHON3: pathC debug ended at: $end_time\n\n"
set fp [open ".pathC_time" r]
set start_time [gets $fp]
close $fp
	puts "\n\n***VLSITHON3: Time spent on pathC: [expr ($end_time - $start_time)/60 ] minutes***\n\n"
	exit
} else { pathC_load }
}

