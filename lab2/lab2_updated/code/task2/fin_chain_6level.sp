.TITLE finfet_chain
.lib "./LAB1_LIB/FINFET/models" ptm16hp

.option post
.global vdd gnd
.temp 25

.param supply = 0.65V
.param length = 14nm




.subckt inv in out l=length n1=1 n2=1
xnmos out in gnd gnd nfet l=length NFIN=n1
xpmos out in vdd vdd pfet l=length NFIN=n2
.ends

x1 vin1 vout1 inv 
x2 vout1 vout2 inv n1=2 n2=2
x3 vout2 vout3 inv n1=6 n2=6
x4 vout3 vout4 inv n1=16 n2=16
x5 vout4 vout5 inv n1=39 n2=39
x6 vout5 vout6 inv n1=98 n2=98
xload vout6 gnd inv n1=256 n2=256

vs vin1 gnd pulse(0,0.65,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply



.TRAN 1ns 9ns 


.measure tran tpLH1
+trig V(vin1)='0.5*supply' fall=2
+targ V(vout1)='0.5*supply' rise=2
.measure tran tpHL1
+trig V(vin1)='0.5*supply' rise=2
+targ V(vout1)='0.5*supply' fall=2
.measure tp1 param='(tpLH1+tpHL2)/2'

.measure tran tpLH2
+trig V(vout1)='0.5*supply' fall=2
+targ V(vout2)='0.5*supply' rise=2
.measure tran tpHL2
+trig V(vout1)='0.5*supply' rise=2
+targ V(vout2)='0.5*supply' fall=2
.measure tp2 param='(tpLH2+tpHL2)/2'

.measure tran tpLH3
+trig V(vout2)='0.5*supply' fall=2
+targ V(vout3)='0.5*supply' rise=2
.measure tran tpHL3
+trig V(vout2)='0.5*supply' rise=2
+targ V(vout3)='0.5*supply' fall=2
.measure tp3 param='(tpLH3+tpHL3)/2'

.measure tran tpLH4
+trig V(vout3)='0.5*supply' fall=2
+targ V(vout4)='0.5*supply' rise=2
.measure tran tpHL4
+trig V(vout3)='0.5*supply' rise=2
+targ V(vout4)='0.5*supply' fall=2
.measure tp4 param='(tpLH4+tpHL4)/2'


.measure tran tpLH5
+trig V(vout4)='0.5*supply' fall=2
+targ V(vout5)='0.5*supply' rise=2
.measure tran tpHL5
+trig V(vout4)='0.5*supply' rise=2
+targ V(vout5)='0.5*supply' fall=2
.measure tp5 param='(tpLH5+tpHL5)/2'


.measure tran tpLH6
+trig V(vout5)='0.5*supply' fall=2
+targ V(vout6)='0.5*supply' rise=2
.measure tran tpHL6
+trig V(vout5)='0.5*supply' rise=2
+targ V(vout6)='0.5*supply' fall=2
.measure tp6 param='(tpLH5+tpHL5)/2'

.measure tp param = 'tp1+tp2+tp3+tp4+tp5+tp6'



.end