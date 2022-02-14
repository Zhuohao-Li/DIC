.TITLE nfinfet_i_measure
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
.temp 90
*********************NMOS**********************
Xnfet d g s b nfet l=lg NFIN=num

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
.DC Vg 0 supply 0.01 sweep num 1 10 1
**********************measure****************
.measure i1 param='80u*(fin_width/lg)'
.measure i2 param='8u*(fin_width/lg)'
.measure dc v1 find v(g) when i(vs)=i1
.measure dc v2 find v(g) when i(vs)=i2
.measure ss param='v1-v2'


.end
