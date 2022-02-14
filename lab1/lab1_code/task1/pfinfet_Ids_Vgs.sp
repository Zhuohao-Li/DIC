*仿真文件TITLE
.TITLE FinFET_P_Ids_V
*调用LIB 这里使用bulksi库
.lib "./LAB1_LIB/FINFET/models" ptm10hp
* 参数设置
.option post
.global vdd gnd
.temp 25
*设置变量

.param SUPPLY = 0.65
.param length = 14n
.param nfin = 10
*.param width = 48n

*********************网表*********************
*mos管
xpfet D G VDD VDD pfet l=length NFIN=nfin
*电压源
VG G GND 0
VD D GND VDD
VDD VDD GND supply
**********************************************

*设置仿真 使用dc仿真 电压从0~0.7 同时扫描W
*.dc VD 0 SUPPLY 0.01 sweep nfin 1 10 1
.dc VG 0 SUPPLY 0.01 sweep nfin 1 10 1
*设置仿真后能够读取Ids值
.probe Id(xpfet)

.alter
.temp 90

.end