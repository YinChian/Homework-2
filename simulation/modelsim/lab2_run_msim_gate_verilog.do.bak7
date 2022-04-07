transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab2.vo}

vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/lab2_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  lab2_tb

add wave *
view structure
view signals
run -all
