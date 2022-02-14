.TITLE 28T
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


.subckt module1 a b xor xnor 
xp1 xor b a vdd pfet l=length NFIN=1
xp2 xor a b vdd pfet l=length NFIN=1
xn1 a b xnor gnd nfet l=length NFIN=1
xn2 b a xnor gnd nfet l=length NFIN=1
xn3 xor a x gnd nfet l=length NFIN=1
xn4 x b gnd gnd nfet l=length NFIN=1
xn5 xor x a gnd nfet l=length NFIN=1
xp3 x a xnor vdd pfet l=length NFIN=1
xp4 vdd b x vdd pfet l=length NFIN=1
xp5 a x xnor vdd pfet l=length NFIN=1
.ends

.subckt module2 xor xnor cin sum
xp8 sum xor cin vdd pfet l=length NFIN=1
xn8 sum xnor cin gnd nfet l=length NFIN=1
xp6 d1 xnor vdd vdd pfet l=length NFIN=1
xp7 sum cin d1 vdd pfet l=length NFIN=1
xn6 sum cin d2 gnd nfet l=length NFIN=1
xn7 d2 xor gnd gnd nfet l=length NFIN=1
.ends

.subckt module3 xor xnor cin cout
xp9 cout xnor cin vdd pfet l=length NFIN=1
xn9 cout xor cin gnd nfet l=length NFIN=1
xp10 cout xor a vdd pfet l=length NFIN=1
xn10 cout xnor b gnd nfet l=length NFIN=1
.ends


x1 a b xor xnor module1
x2 xor xnor cin sum module2
x3 xor xnor cin cout module3

xa ain a inv 
xb bin b inv 
xc cinin cin inv 
xcout cout co inv num=5 
xsum sum sumo inv num=5


* //power
* VA A GND PULSE (0 0.65 2N 50p 50p 4n 8n)
* VB B GND PULSE (0 0.65 2N 50p 50p 2n 4n)
* VC Cin GND PULSE (0 0.65 2N 50p 50p 1n 2n)
* vdd vdd gnd supply
* .tran 0.1n 20n
* .measure tran Power AVG "abs(I(VDD)*V(VDD))" FROM=1ns TO=9ns

* //delay 1
* va ain gnd pulse (0,0.65,1ns,50ps,50ps,1ns,2ns)
* vb bin gnd 0
* vci cinin gnd 0
* vdd vdd gnd supply
* .option post accurate probe
* .probe v(ain) v(bin) v(cinin) v(co) v(sumo)

* .tran 0.1n 10n

* .meas tran tpLH
* +trig v(ain)='0.5*supply' rise=2
* +targ v(sumo)='0.5*supply' rise=2
* .meas tran tpHL
* +trig v(ain)='0.5*supply' fall=2
* +targ v(sumo)='0.5*supply' fall=2
* .measure tp param='(tpLH+tpHL)/2'

* //delay 2
* va ain gnd 0
* vb bin gnd pulse (0,0.65,1ns,50ps,50ps,1ns,2ns)
* vci cinin gnd 0
* vdd vdd gnd supply
* .option post accurate probe
* .probe v(ain) v(bin) v(cinin) v(co) v(sumo)

* .tran 0.1n 10n

* .meas tran tpLH
* +trig v(bin)='0.5*supply' rise=2
* +targ v(sumo)='0.5*supply' rise=2
* .meas tran tpHL
* +trig v(bin)='0.5*supply' fall=2
* +targ v(sumo)='0.5*supply' fall=2
* .measure tp param='(tpLH+tpHL)/2'

* //delay 3
* va ain gnd 0
* vb bin gnd 0
* vci cinin gnd pulse (0,0.65,1ns,50ps,50ps,1ns,2ns)
* vdd vdd gnd supply
* .option post accurate probe
* .probe v(ain) v(bin) v(cinin) v(co) v(sumo)

* .tran 0.1n 10n

* .meas tran tpLH
* +trig v(cinin)='0.5*supply' rise=2
* +targ v(sumo)='0.5*supply' rise=2
* .meas tran tpHL
* +trig v(cinin)='0.5*supply' fall=2
* +targ v(sumo)='0.5*supply' fall=2
* .measure tp param='(tpLH+tpHL)/2'

* //delay 4
* va ain gnd supply
* vb bin gnd 0
* vci cinin gnd pulse (0,0.65,1ns,50ps,50ps,1ns,2ns)
* vdd vdd gnd supply

* .tran 0.1n 10n

* .meas tran tpLH
* +trig v(cinin)='0.5*supply' rise=2
* +targ v(co)='0.5*supply' rise=2
* .meas tran tpHL
* +trig v(cinin)='0.5*supply' fall=2
* +targ v(co)='0.5*supply' fall=2
* .measure tp param='(tpLH+tpHL)/2'

//delay 5
va ain gnd 0
vb bin gnd supply
vci cinin gnd pulse (0 0.65 2N 50p 50p 1n 2n)
vdd vdd gnd supply

.tran 0.1n 10n

.meas tran tpLH
+trig v(cinin)='0.5*supply' rise=2
+targ v(co)='0.5*supply' rise=2
.meas tran tpHL
+trig v(cinin)='0.5*supply' fall=2
+targ v(co)='0.5*supply' fall=2
.measure tp param='(tpLH+tpHL)/2'







.end