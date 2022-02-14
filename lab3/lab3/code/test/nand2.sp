.TITLE finfet_size_gate
.lib "./LAB1_LIB/FINFET/models" ptm16hp

.option post
.global vdd gnd
.temp 25

.param supply = 0.65V
.param length = 14nm
.param n=1

.subckt NAND2 a b out l=length num=n
xnfet1 out b net gnd nfet l=length NFIN='2*num'
xnfet2 net a gnd gnd nfet l=length NFIN='2*num'
xpfet1 out a vdd vdd pfet l=length NFIN=num
xpfet2 out b vdd vdd pfet l=length NFIN=num
.ends

x1 v1 v2 v3 nand2 num='2*n'

v1 v1 gnd pulse(0 1.8 0.1n 0.1n 0.1n 0.5u 1u)
v2 v2 gnd pulse(0 1.8 0.2n 0.1n 0.1n 0.5u 1.3u)
vdd vdd gnd supply

.tran 0.1n 5u

.option post accurate probe
.probe v(v1) v(v2) v(v3)

.end