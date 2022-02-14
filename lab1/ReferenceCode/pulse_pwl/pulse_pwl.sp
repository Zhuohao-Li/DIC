*pulse_pwl.sp
.param SUPPLY=0.7

.temp 70
.option post
*-----------------------------------------------------
* parameters and models
*-----------------------------------------------------
.option node
*-----------------------------------------------------
Vin1 V1 gnd  PULSE(0 'SUPPLY' -10p 10p 10P 190P 400P) *(脉冲源开始前的初始值/脉动值/延迟时间/上升时间/下降时间/脉冲宽度/脉冲周期)
Vin2 V2 gnd  PWL 0 0, 200P SUPPLY,400P 0,600P SUPPLY,800P 0,1000P SUPPLY
Vin3 V3 gnd  PWL 0 0, 190P 0,200P SUPPLY,390P SUPPLY,400P 0,590P 0,600P SUPPLY,790P SUPPLY,800P 0,990P 0,1000P SUPPLY
Vin4 V4 gnd  PWL 0 0, 150P 0,200P SUPPLY,350P SUPPLY,400P 0,550P 0,600P SUPPLY,750P SUPPLY,800P 0,950P 0,1000P SUPPLY

*-----------------------------------------------------
* Stimulus
*-----------------------------------------------------

.tran 1p 1n



.end