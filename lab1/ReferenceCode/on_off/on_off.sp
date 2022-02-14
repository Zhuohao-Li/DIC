.TITLE 16nm_FinFET
***************library**********************
.lib "../../LAB1_LIB/FINFET/models" ptm16hp
********************************************
.option list node post  runlvl=3
.option INGOLD=2
********************parameter*************
.param supply=0.7
.param lg=20n
.param num=1
*********************NMOS**********************
Xnfet d g s b nfet l=lg NFIN=num
*********************power********************
Vg g 0 0
Vd d 0 supply
Vs s 0 0
Vb b 0 0
******************** Intial *********************
.NODESET V(d)=supply
.NODESET V(s)=0
.NODESET V(g)=0
.NODESET V(b)=0
*********************analyze**********************
.DC Vg 0 supply 0.01 sweep num 1 10 1
**********************measure****************
.measure dc Ioff find  I(vs) at=0
.measure dc Ion find  I(vs) at=supply
.measure A param="Ion/Ioff"

.end
