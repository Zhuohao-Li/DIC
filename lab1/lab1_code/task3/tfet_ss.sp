*仿真文件TITLE
.TITLE tfet_Ids_Vgs
*调用LIB 这里使用bulksi库
.hdl "./LAB1_LIB/TFET/heterotfet.va"
* 参数设置
.option post
.global vdd gnd
.temp 25
*设置变量

.param SUPPLY = 0.3
.param width = 0.03
.param Rseries = 55

*********************网表*********************
.subckt nfet d g s w=width

R1 s s1 'Rseries/width'

x1 d1 g s1 tfet type=1 w=width

R2 d d1 'Rseries/width'

.ends
xn d g s nfet w=width

*电压源
VD d gnd SUPPLY
VG g gnd SUPPLY
Vs s gnd 0
vdd vdd gnd supply


**********************************************

*设置仿真 使用dc仿真 电压从0~0.7 同时扫描W
.dc Vg 0 SUPPLY 0.01 sweep width 0.03 0.15 0.03
*.dc VG 0 SUPPLY 0.01 sweep width 24n 120n 24n
*设置仿真后能够读取Ids值
*.probe Id(xnmos)
.measure i1 param='0.1u*(width/0.02)'
.measure i2 param='0.01u*(width/0.02)'
.measure dc v1 find v(g) when i(vs)=-i1
.measure dc v2 find v(g) when i(vs)=-i2
.measure ss param='v1-v2'

.end