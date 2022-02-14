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

x1 v1 v2 inv num=n
x2 v2 v3 inv num='2*n'

vs v1 gnd pulse(0 1.8 0.1n 0.1n 0.1n 0.5u 1u)
vdd vdd gnd supply

.tran 0.1n 5u

.option post accurate probe
.probe v(v1) v(v2) v(v3)

.end