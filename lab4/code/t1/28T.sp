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

.subckt cout28T a b ci cobar size=n
xcout_n_a1 cout_v1 a gnd gnd nfet l=length NFIN='2*size'
xcout_n_b1 cout_v1 b gnd gnd nfet l=length NFIN='2*size'
xcout_n_ci cobar ci cout_v1 gnd nfet l=length NFIN='2*size'
xcout_n_a2 cobar a cout_n_a_b gnd nfet l=length NFIN='2*size'
xcout_n_b2 cout_n_a_b b gnd gnd nfet l=length NFIN='2*size'

xcout_p_a1 cobar a cout_p_a_b vdd pfet l=length NFIN='4*size'
xcout_p_b1 cout_p_a_b b cout_p_b_a vdd pfet l=length NFIN='4*size'
xcout_p_a2 cout_p_b_a a vdd vdd pfet l=length NFIN='2*size'
xcout_p_b2 cout_p_ci_b b vdd vdd pfet l=length NFIN='2*size'
xcout_p_ci cobar ci cout_p_ci_b vdd pfet l=length NFIN='2*size'

.ends

.subckt sum28T a b ci cobar sbar size=n
xsum_n_co sbar cobar co_n gnd nfet l=length NFIN='2*size'
xsum_n_a1 co_n a gnd gnd nfet l=length NFIN='2*size'
xsum_n_b1 co_n b gnd gnd nfet l=length NFIN='2*size'
xsum_n_ci1 co_n ci gnd gnd nfet l=length NFIN='2*size'
xsum_n_ci2 sbar ci sum_n_a_ci gnd nfet l=length NFIN='3*size'
xsum_n_a2 sum_n_a_ci a sum_n_a_b gnd nfet l=length NFIN='3*size'
xsum_n_b2 sum_n_a_b b gnd gnd nfet l=length NFIN='3*size'

xsum_p_co sbar cobar sum_v1 vdd pfet l=length NFIN='2*size'
xsum_p_ci2 sbar ci sum_p_ci_b vdd pfet l=length NFIN='6*size'
xsum_p_b2 sum_p_ci_b b sum_p_b_a vdd pfet l=length NFIN='6*size'
xsum_p_a2 sum_p_b_a a sum_v1 vdd pfet l=length NFIN='6*size'
xsum_p_a1 sum_v1 a vdd vdd pfet l=length NFIN='2*size'
xsum_p_b1 sum_v1 b vdd vdd pfet l=length NFIN='2*size'
xsum_p_ci1 sum_v1 ci vdd vdd pfet l=length NFIN='2*size'
.ends



xcout28T a b ci cobar cout28T 
xsum28T a b ci cobar sbar sum28T
xcout cobar cout inv
xsum sbar sum inv

xa ain a inv 
xb bin b inv 
xc cinin ci inv 
xco cout co inv num=5 
xsumo sum sumo inv num=5



* //power
* VA A GND PULSE (0 0.65 2N 50p 50p 4n 8n)
* VB B GND PULSE (0 0.65 2N 50p 50p 2n 4n)
* VC Ci GND PULSE (0 0.65 2N 50p 50p 1n 2n)
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