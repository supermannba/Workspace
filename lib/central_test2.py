#!/usr/bin env python 3.4

import os
import subprocess 
import androiddevicebt2
from androiddevicebt2 import Androiddevicebt2
from utils.adbwrapper import adbwrapper
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest
import loggingv1,sys

adbwrapper1=adbwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))
