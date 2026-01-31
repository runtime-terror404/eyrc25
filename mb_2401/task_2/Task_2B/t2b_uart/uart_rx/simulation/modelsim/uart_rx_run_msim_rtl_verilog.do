transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/divine/eyrc25/mb_2401/task_2/Task_2B/t2b_uart/uart_rx/code {/home/divine/eyrc25/mb_2401/task_2/Task_2B/t2b_uart/uart_rx/code/uart_rx.v}

vlog -vlog01compat -work work +incdir+/home/divine/eyrc25/mb_2401/task_2/Task_2B/t2b_uart/uart_rx/.test {/home/divine/eyrc25/mb_2401/task_2/Task_2B/t2b_uart/uart_rx/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 1000 us
