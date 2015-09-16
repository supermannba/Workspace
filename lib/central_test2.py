#!/usr/bin env python 3.4

import os
import subprocess 
import androiddevicebt2
from utils.tcpwrapper import Tcpwrapper
from androiddevicebt2 import Androiddevicebt2
from utils.adbwrapper import adbwrapper
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest
import loggingv1,sys

adbwrapper1=adbwrapper()
tcpwrapper1=Tcpwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))


#start scan for name

#second step to configure the DLE
dut[0].createcommanfile2(commanfile)

