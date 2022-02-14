*仿真文件TITLE
.TITLE FinFET_N_Ids_V
*调用LIB 这里使用bulksi库
.lib "./LAB1_LIB/FINFET/models" ptm10hp
* 参数设置
.option post
.global vdd gnd
.temp 25
.probe V(*) I(*)
*设置变量

.param SUPPLY = 0.65
.param length = 14n
.param nfin = 10
*.param width = 48n

*********************网表*********************
*mos管
xnfet D G GND GND nfet l=length NFIN=nfin
*电压源
VG G GND SUPPLY
VD D GND SUPPLY
**********************************************

*设置仿真 使用dc仿真 电压从0~0.7 同时扫描W
*.dc VD 0 SUPPLY 0.01 sweep nfin 1 10 1
.dc VG 0 SUPPLY 0.01 sweep nfin 1 10 1
*设置仿真后能够读取Ids值
*.probe Id(xnfet)

.alter
.temp 90

.end