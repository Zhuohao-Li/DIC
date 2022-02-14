.TITLE bulk_c_1
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk

.option post
.global vdd gnd
.temp 25

.param supply = 0.7V
.param length = 16nm
.param n_width = 24nm
.param p_width = 36nm
.param Cdelay = 1.8fF

.subckt inv in out l=16nm w1=24nm w2=36nm
xnmos out in gnd gnd nfet l=length w=w1
xpmos out in vdd vdd pfet l=length w=w2
.ends

x1 vin1 vout1 inv 
x2 vout1 gnd inv
x3 vin1 g inv
* x2 vout1 vout2 inv w1='4*24n' w2='4*36n'
* x3 vout2 vout3 inv w1='8*24n' w2='8*36n'
* x4 vout3 vout4 inv w1='32*24n' w2='32*36n'
* x5 vout4 cout inv w1='128*24n' w2='128*36n'
*x6 vout2 g inv w1='8*24n' w2='8*36n'
C g gnd Cdelay 

vs vin1 gnd pulse(0,0.7,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply


.TRAN 1ns 9ns sweep Cdelay 0.05fF 0.1fF 0.001fF

.measure tran tpLH1
+trig V(vin1)='0.5*supply' fall=2
+targ V(g)='0.5*supply' rise=2
.measure tran tpHL1
+trig V(vin1)='0.5*supply' rise=2
+targ V(g)='0.5*supply' fall=2
.measure tran tpLH2
+trig V(vin1)='0.5*supply' fall=2
+targ V(vout1)='0.5*supply' rise=2
.measure tran tpHL2
+trig V(vin1)='0.5*supply' rise=2
+targ V(vout1)='0.5*supply' fall=2
.measure tp1 param='(tpLH1+tpHL1)/2'
.measure tp2 param='(tpLH2+tpHL2)/2'


.end



