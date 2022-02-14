.TITLE pmos_r_measure
***************library**********************
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk
********************************************
.option list node post  runlvl=3

********************parameter*************
.param supply=0.7
.param lg=16n
.param width=24n
.global vdd gnd
.temp 25
*********************NMOS**********************
Xpmos d g s b pfet l=lg w=width

*********************power********************
Vg g 0 0
Vd d 0 0
Vs s 0 supply
Vb b 0 supply
vdd vdd gnd supply
******************** Intial *********************
.NODESET V(d)=0
.NODESET V(s)=supply
.NODESET V(g)=0
.NODESET V(b)=supply
*********************analyze**********************
.DC Vd 0 supply 0.01 sweep width 24n 120n 24n
**********************measure****************
.measure dc imid find  I(vs) at=supply/2
.measure dc ion find  I(vs) at=0
.measure ron param="((vdd/(2*imid))+(vdd/ion))/2"

.alter
.temp 90

.end
