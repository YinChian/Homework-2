transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/edge_detect.v}
vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/mod_1sec.v}
vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/lab2.v}
vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/debounce.v}
vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/counter.v}
vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/lcm_ctrl.v}

vlog -vlog01compat -work work +incdir+D:/Digital_Logic_Design/Pratice/Homework\ 2 {D:/Digital_Logic_Design/Pratice/Homework 2/lab2_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lab2_tb

add wave *
view structure
view signals
run -all
