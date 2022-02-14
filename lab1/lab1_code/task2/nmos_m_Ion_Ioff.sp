.TITLE nmos_i_measure
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
Xnmos d g s b nfet l=lg w=width

*********************power********************
Vg g 0 supply
Vd d 0 supply
Vs s 0 0
Vb b 0 0
vdd vdd gnd supply
******************** Intial *********************
.NODESET V(d)=supply
.NODESET V(s)=0
.NODESET V(g)=supply
.NODESET V(b)=0
*********************analyze**********************
.DC Vg 0 supply 0.01 sweep width 24n 120n 24n
**********************measure****************
.measure dc Ioff find  I(vs) at=0
.measure dc Ion find  I(vs) at=supply
.measure A param="Ion/Ioff"

.alter
.temp 90

.end
