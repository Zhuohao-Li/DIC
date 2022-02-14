.TITLE finfet_c_1
.lib "./LAB1_LIB/FINFET/models" ptm16hp

.option post
.global vdd gnd
.temp 25

.param supply = 0.65V
.param length = 14nm
* .param n_width = 24nm
* .param p_width = 36nm
.param Cdelay = 1.8fF


.subckt inv in out l=length n1=1 n2=1
xnmos out in gnd gnd nfet l=length NFIN=n1
xpmos out in vdd vdd pfet l=length NFIN=n2
.ends

x1 vin1 vout1 inv 
x2 vout1 vout2 inv n1='4*1' n2='4*1'
x3 vout2 vout3 inv n1='8*1' n2='8*1'
x4 vout3 vout4 inv 
x5 vout4 vout5 inv n1='128*1' n2='128*1'
x6 vout2 g inv n1='8*1' n2='8*1'
C g gnd Cdelay 

vs vin1 gnd pulse(0,0.65,1ns,50ps,50ps,1ns,2ns)
vdd vdd gnd supply

.TRAN 1ns 9ns sweep Cdelay 1.5fF 2fF 0.05fF

.measure tran tpLH1
+trig V(vout2)='0.5*supply' fall=2
+targ V(g)='0.5*supply' rise=2
.measure tran tpHL1
+trig V(vout2)='0.5*supply' rise=2
+targ V(g)='0.5*supply' fall=2
.measure tran tpLH2
+trig V(vout2)='0.5*supply' fall=2
+targ V(vout3)='0.5*supply' rise=2
.measure tran tpHL2
+trig V(vout2)='0.5*supply' rise=2
+targ V(vout3)='0.5*supply' fall=2
.measure tp1 param='(tpLH1+tpHL1)/2'
.measure tp2 param='(tpLH2+tpHL2)/2'


.end