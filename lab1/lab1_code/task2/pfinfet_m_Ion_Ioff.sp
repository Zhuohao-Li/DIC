.TITLE pfinfet_i_measure
***************library**********************
.lib "./LAB1_LIB/FINFET/models" ptm16hp
********************************************
.option list node post  runlvl=3

********************parameter*************
.param supply=0.65
.param lg=14n
.param num=10
.param fin_height=21n
.param fin_width=9n
.global vdd gnd
.temp 25
*********************NMOS**********************
Xpfet d g s b pfet l=lg NFIN=num

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
.DC Vg 0 supply 0.01 sweep num 1 10 1
**********************measure****************
.measure weff param="2*fin_height+fin_width"
.measure dc Ioff find I(vs) at=supply
.measure dc Ion find I(vs) at=0
.measure A param="Ion/Ioff"

.alter
.temp 90

.end
