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


xa3 va3 v3p inv
xa2 va2 v2p inv
xa1 va1 v1p inv
xa0 va0 v0p inv
xb3 v3p v3n inv
xb2 v2p v2n inv
xb1 v1p v1n inv
xb0 v0p v0n inv
xnand1 v3n v2n vo1 NAND2 num='4*n'
xnand2 v1n v0n vo2 NAND2 num='4*n'
xnor2 vo1 vo2 vo NOR2 num='19*n'
xb1 vo voo inv num=158
xb2 voo vooo inv num=850
xout vooo vout inv num=256

va3 va3 gnd pulse(0,0.65,1ns,50ps,50ps,1ns,2ns)
va2 va2 gnd supply
va1 va1 gnd supply
va0 va0 gnd supply
vdd vdd gnd supply

.tran 0.1n 10n
.option post accurate probe
.probe v(va3) v(v3p) v(v2p) v(v1p) v(v0p) v(vo1) v(vo2) v(vo) v(vout) 

.meas tran tpLH
+trig v(va3)='0.5*supply' rise=2
+targ v(vo)='0.5*supply' rise=2
.meas tran tpHL
+trig v(va3)='0.5*supply' fall=2
+targ v(vo)='0.5*supply' fall=2
.measure tp param='(tpLH+tpHL)/2'

.end