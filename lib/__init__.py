#!/usr/bin env python 3.4

import os
import subprocess 
import adbmodule
import enums,test,time
import androiddevicebt
from Basetest import Basetest

'''device initiliazation'''
#devicelist=adbmodule.initialization()
dut=adbmodule.initializedut()
test=Basetest
time.sleep(1)
logname=[]
for i in range(len(dut)):
	test.initialize(dut[i].deviceid,dut[i])
	logname.append(creatlogfile(dut[i].deviceid))










