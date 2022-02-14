.TITLE bulk_chain
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk

.option post
.global vdd gnd vdd2
.temp 25

.param supply = 0.7V
.param supplyload = 0.7v
.param length = 16nm
.param n_width = 24nm
.param p_width = 36nm



.subckt inv in out l=length w1=24nm w2=36nm
xnmos out in gnd gnd nfet l=length w=w1
xpmos out in vdd vdd pfet l=length w=w2
.ends

.subckt invload in out l=length w1=24nm w2=36nm
xnmos out in gnd gnd nfet l=length w=w1
xpmos out in vdd2 vdd2 pfet l=length w=w2 
.ends

x1 vin1 vout1 inv 
x2 vout1 vout2 inv w1='4*24n' w2='4*36n'
x3 vout2 vout3 inv w1='16*24n' w2='16*36n'
x4 vout3 vout4 inv w1='64*24n' w2='64*36n'
//xload vout4 vout5 invload w1='256*24n' w2='256*36n'

vs vin1 gnd pulse(0,0.7,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply
vdd2 vdd2 gnd supplyload



.TRAN 1ns 9ns 

.MEASURE TRAN avgpower AVG P(VDD) FROM=1ns TO=9ns



.end