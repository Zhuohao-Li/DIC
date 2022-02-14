.TITLE pfinfet_r_measure
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
.DC Vd 0 supply 0.01 sweep num 1 10 1
**********************measure****************
.measure dc imid find  I(vs) at=supply/2
.measure dc ion find  I(vs) at=0
.measure ron param="((vdd/(2*imid))+(vdd/ion))/2"


.alter
.temp 90

.end
