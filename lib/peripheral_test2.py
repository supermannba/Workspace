#!/usr/bin env python 3.4

import os
import subprocess 
from utils.adbwrapper import adbwrapper
from utils.tcpwrapper import Tcpwrapper
import subprocess
import enums,test,time,datetime
import androiddevicebt2
from androiddevicebt2 import Androiddevicebt2
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
# dut[0].removecommandfile(androiddevicebt2.commandfile)
# dut[0].createcommandfile2(androiddevicebt2.commandfile)
# dut[0].turnonBTLE()
# dut[0].advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=androiddevicebt2.advname,remotehost='WCONNECT-BT-39')
# dut[0].startstop(androiddevicebt2.commandfile)
# adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result=dut[0].verifycommands(androiddevicebt2.objectpath,androiddevicebt2.commandfile,androiddevicebt2.resultfile)
print(result)
# commandresult=dut[0].verifycommandpass(result[1])
# print(commandresult)
# if command:
# 	tcpwrapper1.senddata(utils.enums.noticeevent.advertising)



















	









