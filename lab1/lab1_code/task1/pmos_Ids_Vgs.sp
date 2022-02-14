*仿真文件TITLE
.TITLE Bulk_Si_MOSFET_P_Ids_Vgs
*调用LIB 这里使用bulksi库
.lib "./LAB1_LIB/BULK/models" ptm16hp_bulk
* 参数设置
.option post
.global vdd gnd
.temp 25
*设置变量

.param SUPPLY = 0.7
.param length = 16n
.param width = 24n

*********************网表*********************
*mos管
xpmos D G VDD VDD pfet l=length w=width
*电压源
VG G GND 0
VD D GND SUPPLY
VDD VDD GND SUPPLY
**********************************************

*设置仿真 使用dc仿真 电压从0~0.7 同时扫描W
*.dc VD 0 SUPPLY 0.01 sweep width 24n 120n 24n
.dc VG SUPPLY 0 0.01 sweep width 24n 120n 24n
*设置仿真后能够读取Ids值
.probe Id(xpmos)

.alter
.temp 90

.end