#!/usr/bin env python 3.4

import os
import subprocess 
import sys
sys.path.insert(0,'C:\\Users\\asiaynrf\\Documents\\GitHub\\Workspace\\lib')
import utils.tcpwrapper
import utils.adbwrapper
from utils.adbwrapper import adbwrapper
from utils.tcpwrapper import Tcpwrapper
import subprocess
import enums,test,time,datetime
import androiddevicebt2
from androiddevicebt2 import Androiddevicebt2
import loggingv1

'''device initiliazation'''
#devicelist=adbmodule.initialization()
testname="MA 6 instances"
instancenumber=input("Please input the number of advertising instance you want to advertise:")
adbwrapper1=adbwrapper()
tcpwrapper1=Tcpwrapper()
devicelist=adbwrapper1.adbdevice()
dut=[]
for device in devicelist:
	dut.append(Androiddevicebt2(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt2.commandfile,objectpath=androiddevicebt2.objectpath))

'''start initialization'''
adbwrapper1.initialization()
dut[0].initialize(androiddevicebt2.commandfile)
dut[0].setname(1,androiddevicebt2.advname)
numberlist=int(instancenumber)
for i in range(numberlist):
	dut[0].advertising(serial=1,instance=i+1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.notconnectable.value,timeout=0,datalength=251)
dut[0].startstop(androiddevicebt2.commandfile)
adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result=dut[0].verifycommands(androiddevicebt2.objectpath,androiddevicebt2.commandfile,androiddevicebt2.resultfile,androiddevicebt2.outputfile)
if result[0]:
	print("test of {} is pass, test execution finished".format(testname))
else:
	print("test of {} is failed, check the failed reason".format(testname))
	for line in result[1]:
		if 'FAIL' in line:
			print("the failed command during execution of test is:{}".format(line))
time.sleep(600)
dut[0].setupcommandfile(androiddevicebt2.commandfile)
for i in range(numberlist):
	dut[0].stopadvertising(i+1)
dut[0].startstop(androiddevicebt2.commandfile)
adbwrapper1.adbpush(dut[0].deviceid,dut[0].commandfile,androiddevicebt2.objectpath)
result=dut[0].verifycommands(androiddevicebt2.objectpath,androiddevicebt2.commandfile,androiddevicebt2.resultfile,androiddevicebt2.outputfile)
if result[0]:
	print("test of {} is cleaned, test execution finished".format(testname))
else:
	print("test of {} is failed, check the failed reason".format(testname))
	for line in result[1]:
		if 'FAIL' in line:
			print("the failed command during execution of test is:{}".format(line))
# if(dut[0].verifycommandpass(result[1])):
# 	tcpwrapper1.senddata(utils.enums.noticeevent.advertising)



















	









