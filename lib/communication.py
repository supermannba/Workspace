#!/usr/bin env python 3.4

import androiddevicebt
from androiddevicebt import Androiddevicebt
import adbmodule
import sendcommand 
import logging
import loggingv1
import time

logger=loggingv1.logging1(0)

try:
	devicelist=adbmodule.adbdevice()
except Exception as e:
	print(e)
dut=[]


'''Setup the DUT class'''

adbmodule.adbwaitfordevice()
for device in devicelist:
	dut.append(Androiddevicebt(deviceid=device,bt=True,btle=True,commandfile=androiddevicebt.commandfile,objectpath=androiddevicebt.objectpath))
	adbmodule.adbroot(device)

dut1=dut[0]
if len(dut)==2:
	dut2=dut[1]
elif len(dut)==3:
	dut2=dut[1]
	dut3=dut[2]

'''initialize BT'''
dut1.turnonBT(devicelist[0])
dut1.turnonLE(devicelist[0])








