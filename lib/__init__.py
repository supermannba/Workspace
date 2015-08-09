#!/usr/bin env python 3.4

import os
import subprocess 
import adbmodule
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest
import loggingv1,sys

'''device initiliazation'''
#devicelist=adbmodule.initialization()
dut=adbmodule.initializedut()
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
	test.initialize(dut[i])

'''DUT1 start advertising'''
test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,dut1=dut[0])

dut[1].scanforname(serial=1,name=advname)
dut[0].advaddr=dut[1].advaddr

'''enablenotification'''
test.scanandconnect(serial=1,deviceaddr=dut[0].advaddr,dut1=dut[1])
test.writedescriptor(serial=1,deviceaddr=dut[0].advaddr,UUID16bit=enums.UUID16bit.UUID0.value,Characteristic=enums.Characteristic.CIO0.value,Descriptor=enums.Descriptor.DES0.value,operation1=enums.readwriteoperation.operationwrite.value,writedata=enums.writedata.notification.value,dut1=dut[1])

time.sleep(15)
for i in range(len(dut)):
	process[i].kill()
sys.exit(0)






	









