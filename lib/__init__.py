#!/usr/bin env python 3.4

import os
import subprocess 
import adbmodule
import sendcommand
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest

'''device initiliazation'''
#devicelist=adbmodule.initialization()
dut=adbmodule.initializedut()
test=Basetest
time.sleep(5)
logname=[]
testname='Test1'
advname='cstadv'

logpath=adbmodule.createlogpath(testname)


for i in range(len(dut)):	
	logname.append(dut[i].creatlogfile(logpath))
	test.initialize(dut[i])


#test.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,name=advname,dut1=dut[0])

#dut[1].scanforname(serial=1,name=advname)



	









