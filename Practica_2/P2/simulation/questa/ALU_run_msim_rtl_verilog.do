transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/johan/OneDrive\ -\ Universidad\ de\ Antioquia/Semestre\ VI/Elec.\ Digital\ II/Laboratorio/Digital_II/Practica_2/P2 {C:/Users/johan/OneDrive - Universidad de Antioquia/Semestre VI/Elec. Digital II/Laboratorio/Digital_II/Practica_2/P2/multiplierunit.sv}

