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
devicelist=adbmodule.initialization()
dut=adbmodule.initializedut()
test=Basetest
time.sleep(7)
logname=[]
logcatname=[]
process=[]
testname='Test1'
advname='cstadv'

logpath=adbmodule.createlogpath(testname)


for i in range(len(dut)):	
	logname.append(dut[i].creatlogfile(logpath))
	logcatname.append(dut[i].logcatname())
#	loggingv1.cleanlogcat(dut[i].deviceid)
	time.sleep(2)
#	process.append(loggingv1.startlogcat(dut[i].deviceid,logcatname[i]))
	test.initialize(dut[i])

number=input("please input the number of instance you want:")
number1=int(number)
for i in range(number1):
	test.advertising(serial=i+1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,dut1=dut[0])
# dut[1].scanforname(serial=1,name=advname)
# dut[0].advaddr=dut[1].advaddr
# peripheralPCname=enums.networkpath.BTTESTWS2.name
# sendcommand.notifyremote(enums.Filename.notifyfile.value,host=peripheralPCname)


# time.sleep(15)
# for i in range(len(dut)):
# 	process[i].kill()
# sys.exit(0)






	









