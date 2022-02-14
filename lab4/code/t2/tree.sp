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


.subckt adder a b cin sum cout
x_module1 a b xor xnor module1
x_module2 xor xnor cin sum module2
x_module3 xor xnor cin cout module3
.ends

x_adder1 b11 b12 gnd s1 c1 adder
x_adder2 b21 b22 gnd s2 c2 adder
x_adder3 b31 b32 gnd s3 c3 adder
x_adder4 b41 b42 gnd s4 c4 adder
x_adder5 b51 b52 gnd s5 c5 adder
x_adder6 b61 b62 GND s6 c6 adder
x_adder7 b71 b72 gnd s7 c7 adder
x_adder8 b81 b82 gnd s8 c8 adder

x_adder2_1 c1 c2 c2_2 s2_1 c2_1 adder
x_adder2_2 s1 s2 gnd s2_2 c2_2 adder
x_adder2_3 c3 c4 c2_4 s2_3 c2_3 adder
x_adder2_4 s3 s4 gnd s2_4 c2_4 adder
x_adder2_5 c5 c6 c2_6 s2_5 c2_5 adder
x_adder2_6 s5 s6 gnd s2_6 c2_6 adder
x_adder2_7 c7 c8 c2_8 s2_7 c2_7 adder
x_adder2_8 s7 s8 gnd s2_8 c2_8 adder

x_adder3_1 c2_1 c2_3 c3_2 s3_1 c3_1 adder
x_adder3_2 s2_1 s2_3 c3_3 s3_2 c3_2 adder
x_adder3_3 s2_2 s2_4 gnd s3_3 c3_3 adder
x_adder3_4 c2_5 c2_7 c3_5 s3_4 c3_4 adder
x_adder3_5 s2_5 s2_7 c3_6 s3_5 c3_5 adder
x_adder3_6 s2_6 s2_8 gnd s3_6 c3_6 adder

x_adder4_1 c3_1 c3_4 c4_2 s4_1 c4_1 adder
x_adder4_2 s3_1 s3_4 c4_3 s4_2 c4_2 adder
x_adder4_3 s3_2 s3_5 c4_4 s4_3 c4_3 adder
x_adder4_4 s3_3 s3_6 gnd s4_4 c4_4 adder

* xi1 b1 b11 inv
* xi2 b2 b12 inv
* xi3 b3 b21 inv
* xi4 b4 b22 inv
* xi5 b5 b31 inv
* xi6 b6 b32 inv
* xi7 b7 b41 inv
* xi8 b8 b42 inv
* xi9 b9 b51 inv
* xi10 b10 b52 inv
* xi11 b11 b61 inv
* xi12 b12 b62 inv
* xi13 b13 b71 inv
* xi14 b14 b72 inv
* xi15 b15 b81 inv
* xi16 b16 b82 inv

* xco c4_1 co inv num=5
* xo4 s4_1 s4 inv num=5
* xo3 s4_2 s3 inv num=5
* xo2 s4_3 s2 inv num=5
* xo1 s4_4 s1 inv num=5

* v1 b1 gnd 0
* v2 b2 gnd 0
* v3 b3 gnd 0
* v4 b4 gnd 0
* v5 b5 gnd 0
* v6 b6 gnd 0
* v7 b7 gnd 0
* v8 b8 gnd 0
* v9 b9 gnd 0
* v10 b10 gnd 0
* v11 b11 gnd 0
* v12 b12 gnd 0
* v13 b13 gnd 0
* v14 b14 gnd 0
* v15 b15 gnd supply
* v16 b16 gnd PULSE (0 0.65 1N 50p 50p 1n 2n)
* vdd vdd gnd supply
* .tran 0.1n 20n


v1 b11 gnd supply
v2 b12 gnd supply
v3 b21 gnd supply
v4 b22 gnd supply
v5 b31 gnd supply
v6 b32 gnd supply
v7 b41 gnd supply
v8 b42 gnd supply
v9 b51 gnd supply
v10 b52 gnd supply
v11 b61 gnd supply
v12 b62 gnd supply
v13 b71 gnd supply
v14 b72 gnd supply
v15 b81 gnd supply
v16 b82 gnd PULSE (0 0.65 1N 50p 50p 1n 2n)
vdd vdd gnd supply

.tran 0.1n 20n

.meas tran tpLH
+trig v(b82)='0.5*supply' rise=2
+targ v(c4_1)='0.5*supply' rise=2
.meas tran tpHL
+trig v(b82)='0.5*supply' fall=2
+targ v(c4_1)='0.5*supply' fall=2
.measure tp param='(tpLH+tpHL)/2'


* v1 b11 gnd supply
* v2 b12 gnd supply
* v3 b21 gnd supply
* v4 b22 gnd supply
* v5 b31 gnd supply
* v6 b32 gnd supply
* v7 b41 gnd supply
* v8 b42 gnd supply
* v9 b51 gnd supply
* v10 b52 gnd supply
* v11 b61 gnd supply
* v12 b62 gnd supply
* v13 b71 gnd supply
* v14 b72 gnd supply
* v15 b81 gnd supply
* v16 b82 gnd PULSE (0 0.65 2N 50p 50p 1n 2n)
* vdd vdd gnd supply

* .tran 0.1n 20n


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








.end