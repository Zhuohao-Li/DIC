.TITLE bulk_chain
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk

.option post
.global vdd gnd
.temp 25

.param supply = 0.7V
.param length = 16nm
.param n_width = 24nm
.param p_width = 36nm



.subckt inv in out l=16nm w1=24nm w2=36nm
xnmos out in gnd gnd nfet l=length w=w1
xpmos out in vdd vdd pfet l=length w=w2
.ends

x1 vin1 vout1 inv 
x2 vout1 vout2 inv w1='2*24n' w2='2*36n'
x3 vout2 vout3 inv w1='4*24n' w2='4*36n'
x4 vout3 vout4 inv w1='8*24n' w2='8*36n'
x5 vout4 vout5 inv w1='16*24n' w2='16*36n'
x6 vout5 vout6 inv w1='32*24n' w2='32*36n'
x7 vout6 vout7 inv w1='64*24n' w2='64*36n'
x8 vout7 vout8 inv w1='128*24n' w2='128*36n'
xload vout8 gnd inv w1='256*24n' w2='256*36n'


vs vin1 gnd pulse(0,0.7,1ns,50ps,50ps,1ns,2ns)
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
.measure tp6 param='(tpLH6+tpHL6)/2'

.measure tran tpLH7
+trig V(vout6)='0.5*supply' fall=2
+targ V(vout7)='0.5*supply' rise=2
.measure tran tpHL7
+trig V(vout6)='0.5*supply' rise=2
+targ V(vout7)='0.5*supply' fall=2
.measure tp7 param='(tpLH7+tpHL7)/2'

.measure tran tpLH8
+trig V(vout7)='0.5*supply' fall=2
+targ V(vout8)='0.5*supply' rise=2
.measure tran tpHL8
+trig V(vout7)='0.5*supply' rise=2
+targ V(vout8)='0.5*supply' fall=2
.measure tp8 param='(tpLH8+tpHL8)/2'

.measure tp param = 'tp1+tp2+tp3+tp4+tp5+tp6+tp7+tp8'



.end