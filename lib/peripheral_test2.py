#!/usr/bin env python 3.4

import os
import subprocess 
import adbmodule
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt2
from Basetest import Basetest
import loggingv1,sys

'''device initiliazation'''
#devicelist=adbmodule.initialization()
adbwrapper1=adbwrapper()
tcpwrapper1=Tcpwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))


# testname='Test1'
# advname='cstadv'
dut[0].advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,notify=True,remotehost='WCONNECT-BT-39')
adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)














	









