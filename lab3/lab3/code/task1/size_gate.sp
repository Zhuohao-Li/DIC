.TITLE finfet_size_gate
.lib "./LAB1_LIB/FINFET/models" ptm16hp

.option post
.global vdd gnd
.temp 25

.param supply = 0.65V
.param length = 14nm
.param n=1

.subckt inv in out l=length num=n
xnmos out in gnd gnd nfet l=length NFIN=num
xpmos out in vdd vdd pfet l=length NFIN=num
.ends 

.subckt NAND2 a b out l=length num=n
xnfet1 out b net gnd nfet l=length NFIN='2*num'
xnfet2 net a gnd gnd nfet l=length NFIN='2*num'
xpfet1 out a vdd vdd pfet l=length NFIN=num
xpfet2 out b vdd vdd pfet l=length NFIN=num
.ends

.subckt NOR2 a b out l=length num=n
xnfet1 out b gnd gnd nfet l=length NFIN=num
xnfet2 out a gnd gnd nfet l=length NFIN=num
xpfet1 out a net vdd pfet l=length NFIN='2*num'
xpfet2 net b vdd vdd pfet l=length NFIN='2*num'
.ends

x1 va vb inv 
x2 vb vdd vc NAND2 num='2*n'
x3 vc gnd vd NOR2 num='3*n'
x4 vd ve inv num='10*n'
x5 ve vo inv num=10


vs va gnd pulse(0,0.65,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply

.tran 0.1n 10n

.option post accurate probe
.probe v(va) v(vb) v(vc) v(vd) v(ve) v(vo)

.meas tran tpLH
+trig v(va)='0.5*supply' rise=2
+targ v(ve)='0.5*supply' rise=2
.meas tran tpHL
+trig v(va)='0.5*supply' fall=2
+targ v(ve)='0.5*supply' fall=2
.measure tp param='(tpLH+tpHL)/2'

.end