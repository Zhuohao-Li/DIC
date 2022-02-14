.TITLE nfinfet_r_measure
***************library**********************
.lib "./LAB1_LIB/FINFET/models" ptm16hp
********************************************
.option list node post  runlvl=3

********************parameter*************
.param supply=0.65
.param lg=14n
.param num=10
.global vdd gnd
.temp 25
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
.DC Vd 0 supply 0.01 sweep num 1 10 1
**********************measure****************
.measure dc imid find  I(vs) at=supply/2
.measure dc Ion find  I(vs) at=supply
.measure ron param="((vdd/(2*imid))+(vdd/ion))/2"

.alter
.temp 90

.end
