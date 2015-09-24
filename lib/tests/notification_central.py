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
# adbwrapper1.initialization()
# dut[0].initialize(androiddevicebt2.commandfile)
# dut[0].startstop(androiddevicebt2.commandfile)
# adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result=tcpwrapper1.serverreceive(1,utils.enums.noticeevent.advertising.value,'',utils.enums.Tcpport.port3.value)
if result:
	dut[0].scanforname1(1,androiddevicebt2.advname,addrflag=1)
	time.sleep(5)
	if dut[0].remoteaddr:
		print(len(dut[0].remoteaddr))
		dut[0].removecommandfile(dut[0].commandfile)
		dut[0].createcommandfile2(dut[0].commandfile)
		dut[0].turnonLE()
		command1=dut[0].scanandconnect(1,dut[0].remoteaddr,androiddevicebt2.datalength)
		dut[0].startstop(androiddevicebt2.commandfile)
		adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result1=dut[0].verifycommands(androiddevicebt2.objectpath,androiddevicebt2.commandfile,androiddevicebt2.resultfile,androiddevicebt2.outputfile)
if result1[0]:
	tcpwrapper1.sendverify(utils.enums.Hostname.BTTESTWS2.value,utils.enums.noticeevent.notificaitoninterval.value,utils.enums.Tcpport.port4.value)

# tcpwrapper1.sendverify(utils.enums.BTTESTWS2.value,utils.enums.noticeevent.notificaitoninterval.value,utils.enums.Tcpport.port4.value)
# dut[0].writedescriptor(1,utils.enums.UUID16bit.UUID0.value,utils.enums.Characteristic.CID0.value,utils.enums.Descriptor.DES0.value,utils.enums.readwriteoperation.operationwrite.value,writedata=utils.enums.writedata.notification.value)

