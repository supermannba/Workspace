#!/usr/bin env python 3.4

import os
import subprocess,sys
sys.path.insert(0,'C:\\Users\\asiaynrf\\Documents\\GitHub\\Workspace\\lib')
import androiddevicebt2
from utils.tcpwrapper import Tcpwrapper
from androiddevicebt2 import Androiddevicebt2
from utils.adbwrapper import adbwrapper
import androiddevicebt2
import test,time,datetime
import utils.enums


'''configuration'''
adbwrapper1=adbwrapper()
tcpwrapper1=Tcpwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))


'''start test'''
'''start initialization'''
adbwrapper1.initialization()
dut[0].initialize(androiddevicebt2.commandfile)
tcpwrapper1.serverreceive(1,enums.noticeevent.advertising.value,'',enums.Tcpport.port3.value)
if(dut[0].scanforname1(1,androiddevicebt2.advname)):
	dut[0].createcommandfile2(dut[0].commandfile)
	command1=dut[0].scanandconnect(1,dut[0].remoteaddr,androiddevicebt2.datalength)
tcpwrapper1.sendverify(utils.enums.BTTESTWS2.value,enums.noticeevent.notificaitoninterval.value,enums.Tcpport.port4.value)
dut[0].writedescriptor(1,enums.UUID16bit.UUID0.value,enums.Characteristic.CID0.value,enums.Descriptor.DES0.value,enums.readwriteoperation.operationwrite.value,writedata=enums.writedata.notification.value)

