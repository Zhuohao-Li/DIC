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


x1b1 v1b1 v1b2 inv 
x1b2 v1b2 v1 inv

x2b1 v2b1 v2b2 inv 
x2b2 v2b2 v2 inv 

x3b1 v3b1 v3b2 inv
x3b2 v3b2 v3 inv 

x4b1 v4b1 v4b2 inv
x4b2 v4b2 v4 inv 

x5b1 v5b1 v5b2 inv
x5b2 v5b2 v5 inv 

x6b1 v6b1 v6b2 inv
x6b2 v6b2 v6 inv 

x7b1 v7b1 v7b2 inv 
x7b2 v7b2 v7 inv 

x1 v1 v2 v12 NAND2 num=1
x2 v3 v4 v34 NAND2 num=1
x3 v5 v6 v56 NAND2 num=1
x4 v7 v7i inv num=2

x5 v12 v34 v1234 NOR2 num=1
x6 v56 v7i v567i NOR2 num=1

x7 v1234 v567i vo1 NAND2 num=1

x8 vo1 vo2 inv num=1

xo1 vo2 vp1 inv num=5
xo2 vp1 vp2 inv num=19
xo3 vp2 vp3 inv num=38
xo4 vp3 vp inv num=164

xload vp vout inv num=512


v1 v1b1 gnd pulse(0,0.65,1ns,50ps,50ps,1ns,4ns)
v2 v2b1 gnd supply
v3 v3b1 gnd supply
v4 v4b1 gnd supply
v5 v5b1 gnd supply
v6 v6b1 gnd supply
v7 v7b1 gnd supply

vdd vdd gnd supply

.tran 0.1n 50n
//.option post accurate probe
//.probe v(v1) v(vo2) v(v1234) v(v567i) v(vo1) v(vout) v(v34) v(v12) v(v2) v(v1b1)

.meas tran tpLH
+trig v(v1b1)='0.5*supply' rise=2
+targ v(vp)='0.5*supply' rise=2
.meas tran tpHL
+trig v(v1b1)='0.5*supply' fall=2
+targ v(vp)='0.5*supply' fall=2
.measure tp param='(tpLH+tpHL)/2'

.end