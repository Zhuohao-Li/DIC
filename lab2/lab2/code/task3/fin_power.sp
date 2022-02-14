.TITLE finfet_chain
.lib "./LAB1_LIB/FINFET/models" ptm16hp

.option post
.global vdd gnd vdd2
.temp 25

.param supply = 0.65V
.param supplyload = 0.65v
.param length = 14nm




.subckt inv in out l=length n1=1 n2=1
xnmos out in gnd gnd nfet l=length NFIN=n1
xpmos out in vdd vdd pfet l=length NFIN=n2
.ends


.subckt invload in out l=length n1=1 n2=1
xnmos out in gnd gnd nfet l=length NFIN=n1
xpmos out in vdd2 vdd2 pfet l=length NFIN=n2
.ends

x1 vin1 vout1 inv 
x2 vout1 vout2 inv n1=4 n2=4
x3 vout2 vout3 inv n1=16 n2=16
x4 vout3 vout4 inv n1=64 n2=64
xload vout4 vout5 invload n1=256 n2=256

vs vin1 gnd pulse(0,0.65,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply
vdd2 vdd2 gnd supplyload



.TRAN 1ns 9ns 

.MEASURE TRAN avgpower AVG P(VDD) FROM=1ns TO=9ns

.end