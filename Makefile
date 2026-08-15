
CMD:=innovus -wait 60 -files /reference/system.tcl

testcase2:
	gcc mac.c  ; ./a.out input.txt

testcase3:
	$(CMD) -init scripts/$@.tcl


