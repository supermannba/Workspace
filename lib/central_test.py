#!/usr/bin env python 3.4

import os
import subprocess 
from androiddevicebt import Androiddevicebt
import adbmodule
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest
import loggingv1,sys

'''device initiliazation'''
#devicelist=adbmodule.initialization()
devicelist=adbmodule.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt.commandfile,objectpath=androiddevicebt.objectpath))
test=Basetest
time.sleep(5)
logname=[]
logcatname=[]
process=[]
testname='Test1'
advname='cstadv'

logpath=adbmodule.createlogpath(testname)


for i in range(len(dut)):	
	logname.append(dut[i].creatlogfile(logpath))
	logcatname.append(dut[i].logcatname())
	loggingv1.cleanlogcat(dut[i].deviceid)
	time.sleep(2)
	process.append(loggingv1.startlogcat(dut[i].deviceid,logcatname[i]))
	
success=sendcommand.verifyremote(enums.noticeevent.advertisingstart.value,enums.Filename.notifyfile.value)
if success:
	test.scanandconnect(1,advname,dut[0])
	dut[0].configuremtu(1,dut[0].advaddr,251)
	test.writedescriptor(1,enums.UUID16bit.UUID0.value,enums.Characteristic.CID0.value,enums.Descriptor.DES0.value,enums.readwriteoperation.operationwrite.value,writedata=enums.writedata.notification.value,dut1=dut[0])





time.sleep(15)
for i in range(len(dut)):
	process[i].kill()
'''remove the templog file'''
tempfile=enums.networkpath.selfhost.value+enums.Filename.notifyfile.value
os.remove(tempfile)
sys.exit(0)






	









