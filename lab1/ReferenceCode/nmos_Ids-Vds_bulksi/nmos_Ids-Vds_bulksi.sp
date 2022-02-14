*仿真文件TITLE
.TITLE Bulk_Si_MOSFET_N_Ids_Vgs
*调用LIB 这里使用bulksi库
.lib "../../LAB1_LIB/BULK/models" ptm16hp_bulk
* 参数设置
.option post
.global vdd gnd
.temp 25
*设置变量

.param SUPPLY = 0.7
.param length = 16n
.param width = 48n

*********************网表*********************
*mos管
xnmos D G GND GND nfet l=length w=width
*电压源
VG G GND SUPPLY
VD D GND SUPPLY
**********************************************

*设置仿真 使用dc仿真 电压从0~0.7 同时扫描W
.dc VD 0 SUPPLY 0.01 sweep width 48n 480n 48n
*设置仿真后能够读取Ids值
.probe Id(xnmos)

.end