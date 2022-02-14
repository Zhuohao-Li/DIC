*rc.sp
.param SUPPLY=0.7
.option scale=16n
.temp 70
.option post
*-----------------------------------------------------
* parameters and models
*-----------------------------------------------------
.option node
*-----------------------------------------------------
Vin in gnd  PULSE(0 'SUPPLY' 0p 50p 50p 800p 1950p)
R1 in out 20k 
C1 out gnd 10f
*-----------------------------------------------------
* Stimulus
*-----------------------------------------------------
.tran 1p 5n

.measure tran tpLH TRIG V(in)='SUPPLY/2' RISE=2 TARG V(out)='SUPPLY/2' RISE=2
.measure tran tpHL TRIG V(in)='SUPPLY/2' FALL=2 TARG V(out)='SUPPLY/2' FALL=2
.measure tpd PARAM = '(tpLH+tpHL)/2'

.end