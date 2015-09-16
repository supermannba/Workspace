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
#	

test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,notify=True,remotehost='WCONNECT-BT-39',dut1=dut[0])







	









