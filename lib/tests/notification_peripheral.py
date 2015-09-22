#!/usr/bin env python 3.4

import os
import subprocess 
import sys
sys.path.insert(0,'C:\\Users\\asiaynrf\\Documents\\GitHub\\Workspace\\lib')
import utils.tcpwrapper
import utils.adbwrapper
from utils.adbwrapper import adbwrapper
from utils.tcpwrapper import Tcpwrapper
from androiddevicebt2 import Androiddevicebt2
import subprocess
import enums
import test,time,datetime
import androiddevicebt2
import loggingv1,sys

'''device initiliazation'''
#devicelist=adbmodule.initialization()
adbwrapper1=adbwrapper()
tcpwrapper1=Tcpwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))


'''start initialization'''
adbwrapper1.initialization()
dut[0].initialize(androiddevicebt2.commandfile)
numberlist=1
for i in range(numberlist):
	dut[0].advertising(serial=1,instance=i+1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,datalength=251,name=androiddevicebt2.advname,remotehost='WCONNECT-BT-39')
dut[0].startstop(androiddevicebt2.commandfile)
adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result=dut[0].verifycommands(androiddevicebt2.objectpath,androiddevicebt2.commandfile,androiddevicebt2.resultfile,androiddevicebt2.outputfile)
if(dut[0].verifycommandpass(result[1])):
	tcpwrapper1.senddata(utils.enums.noticeevent.advertising)

















	









