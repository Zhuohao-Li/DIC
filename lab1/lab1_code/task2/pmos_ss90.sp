.TITLE pmos_i_measure
***************library**********************
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk
********************************************
.option list node post  runlvl=3

********************parameter*************
.param supply=0.7
.param lg=16n
.param width=24n
.global vdd gnd
.temp 90
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
.DC Vg 0 supply 0.01 sweep width 24n 120n 24n
**********************measure****************
.measure i1 param='1u*(width/lg)'
.measure i2 param='0.1u*(width/lg)'
.measure dc v1 find v(g) when i(vd)=i1
.measure dc v2 find v(g) when i(vd)=i2
.measure ss param='v2-v1'

.end
