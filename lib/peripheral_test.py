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
time.sleep(7)
logname=[]
logcatname=[]
process=[]
testname='Test1'
advname='cstadv11'

logpath=adbmodule.createlogpath(testname)


for i in range(len(dut)):	
	logname.append(dut[i].creatlogfile(logpath))
	logcatname.append(dut[i].logcatname())
	time.sleep(2)
<<<<<<< HEAD
#	process.append(loggingv1.startlogcat(dut[i].deviceid,logcatname[i]))
<<<<<<< HEAD
	test.initialize(dut[i])
dut[0].configurenewservicewithdatalength(1,datalength=251)
test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,dut1=dut[0])
=======
	#test.initialize(dut[i])

test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,notify=True,remotehost='WCONNECT-BT-39',dut1=dut[0])
>>>>>>> 9cf608d1501634a37e9db666e25d24d5de038424
# dut[1].scanforname(serial=1,name=advname)
# dut[0].advaddr=dut[1].advaddr

#success=sendcommand.verifyremote(enums.noticeevent.

=======


test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,notify=True,remotehost='WCONNECT-BT-39',dut1=dut[0])
>>>>>>> origin/master







	









