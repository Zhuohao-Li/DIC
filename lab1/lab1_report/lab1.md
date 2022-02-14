# lab1_report
* name: 李卓壕 
* ID: 519021911248
* date: 2021-10-9

***

  # introduction/background

 
EDA是数字集成电路设计的重要工具，随着微电子技术的迅速发展以及集成电路规模不断提高，对电路性能的设计要求越来越严格，这势必对用于大规模集成电路（VLSI）设计的EDA工具提出越来越高的要求。自1972年美国加利福尼亚大学伯克利分校电机工程和计算机科学系开发的用于集成电路性能分析的电路模拟程序SPICE（Simulation Program with Integrated Circuit Emphasis）诞生以来，为适应现代微电子工业的发展，各种用于集成电路设计的电路模拟分析工具不断涌现。HSPICE 是Meta-Software 公司为集成电路设计中的稳态分析，瞬态分析和频域分析等电路性能的模拟分析而开发的一个商业化通用电路模拟程序，它在伯克利的SPICE（1972年推出），MicroSim公司的PSPICE （1984年推出）以及其它电路分析软件的基础上，又加入了一些新的功能，经过不断的改进，目前已被许多公司、大学和研究开发机构广泛应用。HSPICE 可与许多主要的EDA设计工具，诸如Cadence,Workview等兼容，能提供许多重要的针对集成电路性能的电路仿真和设计结果。采用HSPICE 软件可以在直流到高于100GHz 的微波频率范围内对电路作精确的仿真、分析和优化。在实际应用中， HSPICE能提供关键性的电路模拟和设计方案，并且应用HSPICE进行电路模拟时，其电路规模仅取决于用户计算机的实际存储器容量。


  # lab procedures
  ## task1

tasks1主要是熟悉HSPICE的基本语法。根据reference code，对NMOS， POMS， n-FinFET， p-FinFET进行仿真模拟，并且得到各个元器件的I-V特性曲线。具体的代码在zip里显示。

为了正确仿真出波形，值得注意：
1. 正确用.lib调用模型库
2. 正确定义器件模型
3. 正确施加电压激励
4. 正确用dc语句进行sweep

  ## task2

task2主要分成三个部分
1. Ion和Ioff的测量
   对于nmos和n-channel-FinFET来说，Ion的电流在Vgs=vdd的时候取到，Ioff的电流在Vgs=0的时候取到，而对于pmos和p-channel-FinFET正好相反。事实上，造成这样的区别的的原因是因为n型沟道和p型沟道正常工作时的Vgs极性不同，但是本质上，由Ion（On-State_Current）、Ioff（Off-State-Current）的定义，可以明确区分出Vgs取何值时的Ids是所求的电流。$ \cfrac{Ion}{Ioff} $可以通过.measure语句来精确得到。这在这一部分尤为关键。
2. Ron和Roff的测量
   对于nmos和n-channel-FinFET来说，Ids-Vds的关系如下图所示：
   ![1](1.png)
   观察上图，我们可以利用电阻的定义，通过.measure语句测量得到当$ vds=\cfrac{vdd}{2} $以及当vds=vdd时对应的Ids，然后分别计算两个时刻的电阻值，将他们的平均值作为测量值。这样做的正确性由等效电阻的公式（如下）给出，事实上，这个公式对FinFET和TFET同样适用。
    ![1](2.png)
    关键代码如下：

    ```hspice
        .measure dc imid find  I(vs) at=supply/2
        .measure dc ion find  I(vs) at=supply
        .measure ron param="((vdd/(2*imid))+(vdd/ion))/2"
    ```
    而对于pmos和p-channel-FinFET，两个电阻计算值分别在$ \cfrac{vdd}{2} $ 和 0处取到。这要足够小心。但是只要正确理解各个器件的工作原理，代码实现也不成问题。
3. SS的测量
   ss（subthreshold slope）是用来表征器件漏电流的大小。理论上讲，ss应该为60mv/decade，但是实际上往往控制不住，造成芯片能源的大量损耗。
   ss的测量ppt上已经说得很清楚了，以nmos为例，核心步骤就是在Ids-Vgs的对数图中，将$ Ids=0.1 \mu A \times \cfrac{W}{L}$时的Vgs作为V1，将$ Ids=0.01 \mu A \times \cfrac{W}{L}$时的Vgs作为V2，ss在数值上就等于V1-V2。代码的核心如下：

   ```hspice
        .measure i1 param='0.1u*(width/lg)'
        .measure i2 param='0.01u*(width/lg)'
        .measure dc v1 find v(g) when i(vs)=i1
        .measure dc v2 find v(g) when i(vs)=i2
        .measure ss param='v1-v2'
    ```
    0.1和0.01不是固定的，会根据实际情况进行调整。同时，对于p型沟道的器件，注意要调整v1和v2的顺序。
  ## task3
TFET的仿真要点主要有三个：
1.  正确调用TFET模型库 ：.hdl "./LAB1_LIB/TFET/heterotfet.va"
2. 正确设置TFET的模型参数，它的长度是恒定的（20nm），没有body接口，默认单位是um需要进行单位转换等
3. 正确使用 .subckt .ends 的子电路
 

  # lab results
  ## task1
  task1所仿真出的图像如下：

* ### NMOS
***
$ n-channel\  bulk\ Si-MOSFET,\ Ids-Vds@25^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](nmos_Ids_Vds_25.png)

$ n-channel\  bulk\ Si-MOSFET,\ Ids-Vds@90^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](nmos_Ids_Vds_90.png)

$ n-channel\  bulk\ Si-MOSFET,\ Ids-Vgs@25^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](nmos_Ids_Vgs_25.png)

$ n-channel\  bulk\ Si-MOSFET,\ Ids-Vs@90^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](nmos_Ids_Vgs_90.png)

  
  * ### PMOS
***

$ p-channel\  bulk\ Si-MOSFET,\ Ids-Vds@25^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](pmos_Ids_Vds_25.png)

$ p-channel\  bulk\ Si-MOSFET,\ Ids-Vds@90^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](pmos_Ids_Vds_90.png)

$ p-channel\  bulk\ Si-MOSFET,\ Ids-Vgs@25^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](pmos_Ids_Vgs_25.png)

$ p-channel\  bulk\ Si-MOSFET,\ Ids-Vgs@90^{\circ}C,\\ Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![nmos_Ids_Vds](pmos_Ids_Vgs_90.png)

* ### n-FinFET
***

$ n-channel\  FinFET,\ Ids-Vds@25^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](nfinfet_Ids_Vds_25.png)

$ n-channel\  FinFET,\ Ids-Vds@90^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](nfinfet_Ids_Vds_90.png)

$ n-channel\  FinFET,\ Ids-Vgs@25^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](nfinfet_Ids_Vgs_25.png)

$ n-channel\  FinFET,\ Ids-Vgs@90^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](nfinfet_Ids_Vgs_90.png)

* ### p-FinFET
***

$ p-channel\  FinFET,\ Ids-Vds@25^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](pfinfet_Ids_Vds_25.png)

$ p-channel\  FinFET,\ Ids-Vds@90^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](pfinfet_Ids_Vds_90.png)

$ p-channel\  FinFET,\ Ids-Vgs@25^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](pfinfet_Ids_Vgs_25.png)

$ p-channel\  FinFET,\ Ids-Vgs@90^{\circ}C,\\ Vgs=0.65V,number\ of\ fin=1\to 10 $
![nmos_Ids_Vds](pfinfet_Ids_Vgs_90.png)

##task2

* ### NMOS
***
$ nmos,\ Ion\ and\ Ioff @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_nmos_i.png)

$ nmos,\ ron\ @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_nmos_ron.png)

$ nmos,\ roff\ @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_nmos_roff.png)

$ so\ we\ can\ derive\ \cfrac{ron}{roff} \ above$

$ nmos,\ ss\ @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_nmos_ss25.png)

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion（uA）|59.83|93.95|127.9|161.9|195.8|            
|Ioff(nA)|18.22|29.7|41.21|52.72|64.23|
|$\cfrac{Ion}{Ioff}(\times 10^3)$|3.28|3.16|3.10|3.07|3.047|
|$\cfrac{Ron}{Roff}(\times 10^{-6})$|55.70|59.5|61.89|63.06|63.74|
|ss|99.19|98.47|98.21|98.13|98.08|

$ for\ @90^{\circ}C,\ we\ can\ stimulate\ in\ the\ same\ way.$

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion(uA)| 49.24|78.02 | 106.7| 135.3| 163.9|            
|Ioff(nA)| 41.45| 67.66| 93.88| 120.1| 146.3|
|$\cfrac{Ion}{Ioff}(\times 10^3)$| 1.187| 1.153|1.136 |1.126 |1.12 |
|$\cfrac{Ron}{Roff}(\times 10^{-6})$| 221.63| 232.82|239.67 |243.03 |244.97 |
|ss|142.1 |140.3 |139.4 |139.0 |138.8 |





* ### PMOS
***

$ pmos,\ Ion\ and\ Ioff @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_pmos_i.png)

$ pmos,\ ron\  @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_pmos_ron.png)

$ pmos,\ roff\  @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_nmos_roff.png)

$ so\ we\ can\ derive\ \cfrac{ron}{roff} \ above$

$ pmos,\ ss\  @25^{\circ}C,  Vgs=0.7V,width=3 \lambda  \to 15\lambda $
![1](t2_pmos_ss25.png)

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion(uA)|-40.48 |-64.72 |-88.88 |-113 |-137.1 |            
|Ioff(nA)|-22.75 |-37.19 |-51.64 |-66.1 |-80.55 |
|$\cfrac{Ion}{Ioff}(\times 10^3)$|1.779 |1.74 |1.72 |1.71 |1.70 |
|$\cfrac{Ron}{Roff}(\times 10^{-6})**$**| 67.47| 69.98| 71.78| 72.30| 72.64|
|ss| 130.8|127.1 |125.5 |124.8 |124.3 |


$ for\ @90^{\circ}C,\ we\ can\ stimulate\ in\ the\ same\ way.$

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion(uA)| -25.99|-41.91 |-57.80 |-73.68 |-89.55 |            
|Ioff(nA)| -42.17|-68.95 |-95.74 |-122.5 |-149.3 |
|$\cfrac{Ion}{Ioff}(\times 10^3)$| 0.616| 0.608| 0.604| 0.601| 0.600|
|$\cfrac{Ron}{Roff}(\times 10^{-6})$| 301.24|307.88 |311.86 |313.92 |315.18 |
|ss| 157.2| 152.1| 149.8| 148.7| 148.1|


* ### n-FinFET
***

$ n-channel-FinFET,\ Ion\ and\ Ioff @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](t2_nfinfet_i.png)

$ n-channel-FinFET,\ ron\  @25^{\circ}C,  Vgs=0.65V,width=1\to 10 $
![1](t2_nfinfet_ron.png)

$ n-channel-FinFET,\ roff\  @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](t2_nfinfet_roff.png)

$ so\ we\ can\ derive\ \cfrac{ron}{roff} \ above$

$ n-channel-FinFET,\ ss\  @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](3.png)

the data:
|fin number|1|2|3|4|5|6|7|8|9|10|
|------|------|------|-----|-----|-----|---|---|---|---|---|
|Weff(nm)|51|51|51|51|51|51|51|51|51|51|
|Ion(uA)|55.85|111.71|167.62|223.43|279.34|335.15|391.03|446.82|502.71|558.50          
|Ioff(nA)|351.21|702.50|1054.01|1405.03|1756.23|2107.42|2459.16|2810.22|3161.04|3512.44|
|$\cfrac{Ion}{Ioff}(\times 10^3)$|0.159|0.159|0.159|0.159|0.159|0.159|0.159|0.159|0.159|0.159|
|$\cfrac{Ron}{Roff}\ (\times 10^{-3})$|2.94|2.94|2.94|2.94|2.94|2.94|2.94|2.94|2.94|2.94|
|ss|446|301.1|236.2|199.5|176.5|161.3|150.9|143.2|137.4|133|


$ for\ @90^{\circ}C,\ we\ can\ stimulate\ in\ the\ same\ way.$

the data:
|fin number|1|2|3|4|5|6|7|8|9|10|
|------|------|------|-----|-----|-----|---|---|---|---|---|
|Weff(nm)|51|51|51|51|51|51|51|51|51|51|
|Ion(uA)|61.58|123.21|184.74|246.31|307.92|369.51|431.14|492.71|544.20|615.81|       
|Ioff(nA)|1491|2982|4473|5965|7456|8947|10440|11930|13420|14910|
|$\cfrac{Ion}{Ioff}(\times 10^3)$|0.041|0.041|0.041|0.041|0.041|0.041|0.041|0.041|0.041|0.041|
|$\cfrac{Ron}{Roff}(\times 10^{-3})$|14.0|14.0|14.0|14.0|14.0|14.0|14.0|14.0|14.0|14.0
|ss|512|357.7|281.4|239.4|201.3|183.7|169.2|152.3|143.9|


* ### p-FinFET
***
$ p-channel-FinFET,\ Ion\ and\ Ioff @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](t2_pfinfet_i.png)

$ p-channel-FinFET,\ ron\  @25^{\circ}C,  Vgs=0.65V,width=1\to 10 $
![1](t2_pfinfet_ron.png)

$ p-channel-FinFET,\ roff\  @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](t2_pfinfet_roff.png)

$ so\ we\ can\ derive\ \cfrac{ron}{roff} \ above$

$ p-channel-FinFET,\ ss\  @25^{\circ}C,  Vgs=0.65V,number\ of\ fin=1\to 10 $
![1](4.png)

the data:
|fin number|1|2|3|4|5|6|7|8|9|10|
|------|------|------|-----|-----|-----|---|---|---|---|---|
|Weff(nm)|51|51|51|51|51|51|51|51|51|51|
|Ion(uA)|-49.52|-99.04|-148.6|-198.1|-247.6|-297.1|-346.6|-396.1|-445.7|-495.2|       
|Ioff(nA)|-478.4|-956.8|-1435|-1914|-2392|-2870|-3349|-3827|-4305|-4784
|$\cfrac{Ion}{Ioff}(\times 10^3)$|103.51|103.51|103.51|103.51|103.51|103.51|103.51|103.51|103.51|103.51|
|$\cfrac{Ron}{Roff}(\times 10^{-3})$|3.57|3.57|3.57|3.57|3.57|3.57|3.57|3.57|3.57|3.57
|ss|380.1|329.9|253.5|211.2|185.4|168.5|156.8|148.6|142.2|137.3


$ for\ @90^{\circ}C,\ we\ can\ stimulate\ in\ the\ same\ way.$

the data:
|fin number|1|2|3|4|5|6|7|8|9|10|
|------|------|------|-----|-----|-----|---|---|---|---|---|
|Weff(nm)|51|51|51|51|51|51|51|51|51|51|
|Ion(uA)|-55.45|-110.9|-166.3|-221.8|-277.2|-332.7|-388.1|-443.6|-499.0|-554.5       
|Ioff(uA)|-2.31|-4.62|-6.93|-9.24|-11.5|-13.86|-16.17|-18.48|-20.78|-23.09
|$\cfrac{Ion}{Ioff}$|24.01|24.01|24.01|24.01|24.01|24.01|24.01|24.01|24.01|24.01|24.01
|$\cfrac{Ron}{Roff}$|0.022|0.022|0.022|0.022|0.022|0.022|0.022|0.022|0.022|0.022
|ss|600.2|498.3|380.6|276.4|199.7|170.2|159.4|151.9|146.8|139.0


  
## task3
* ### n-TFET
***
$ n-TFET,\ Ids-Vds\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_ids_vds.png)

$ n-TFET,\ Ids-Vgs\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_ids_vgs.png)

$ n-TFET,\ Ion\ and\ Ioff\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ion_ioff.png)

$ n-TFET,\ ron\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ron.png)

$ n-TFET,\ roff\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_roff.png)

$ n-TFET,\ ss\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ss.png)

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion(uA)| 6.23|12.45 |18.68 |24.91 |31.14 |            
|Ioff(pA)|183.1 |366.1 |549.2 |732.2 |915.3 |
|$\cfrac{Ion}{Ioff}(\times 10^3)$|34.01 | 34.01|34.01 |34.01 | 34.01|
|$\cfrac{Ron}{Roff}(\times 10^{-3})$|0.0298 |0.0298 |0.0298 |0.0298 |0.0298 |
|ss| 37.28| 37.28|37.28 | 37.28| 37.28|

* ### p-TFET
***
$ p-TFET,\ Ids-Vds\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ids_vds_p.png)
$ p-TFET,\ Ids-Vgs\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ids_vgs_p.png)
$ p-TFET,\ Ion\ and\ Ioff\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ion_ioff_p.png)
$ p-TFET,\ ron\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_ron_p.png)
$ p-TFET,\ roff\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $
![1](t3_tfet_roff_p.png)
$ n-TFET,\ ss\ @25^{\circ}C,\\ Vgs=0.3V,width=0.03u\to 0.15u $

the data:
|width|$ 3\lambda $|$ 6\lambda $| $ 9\lambda $|$ 12\lambda $|$ 15\lambda $
|------|------|------|-----|-----|-----|
|Ion(uA)| -6.227|-12.45 |-18.68 |-24.91 |-31.14 |            
|Ioff(pA)|183.1 |366.1 |549.2 |732.2 |915.3 |
|$\cfrac{Ion}{Ioff}(\times 10^3)$|34.01 | 34.01| 34.01| 34.01|34.01 |
|$\cfrac{Ron}{Roff}(\times 10^{-3})$| 0.0298|0.0298 |0.0298 |0.0298 |0.0298 |
|ss| 37.28| 37.28| 37.28|37.28 | 37.28|










# 4.observations and conclusions &Technical analysis of the simulation results
经过仿真发现，mos管作为最传统的数字集成电路的基本组成原件，他性能是最差的，$\cfrac{Ion}{Ioff}$, $\cfrac{Ron}{Roff}$都是这三类原件当中最低的，同时，mos管的亚阈值摆幅（SS）也是以上三者性能中最差的。但是，由于mos管充分的稳定性和较为简单的结构，使得其在数字集成电路的设计的历史长河中占据着重要地位。
Finfet作为目前最广泛使用的集成电路基本元器件，它的性能比mosfet好了不少。leakage电流=得到了足够的抑制，使得他在7nm，5nm甚至更低的制程当中占据主导地位。但是，FinFET的ss也不太稳定，p型管和n型管存在着显著区别。
TFET作为新型材料的代表，展现出来很好的特性。他的leakage低，$\cfrac{Ion}{Ioff}$, $\cfrac{Ron}{Roff}$足够大，ss稳定，可以期待，TFET可以在未来更先进的VLSI上发挥更大的作用。