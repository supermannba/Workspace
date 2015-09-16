#!/usr/bin env python 3.4

import os
import subprocess 
from utils.adbmodule import adbwrapper
import sendcommand,subprocess
import enums,test,time,datetime
import androiddevicebt
from Basetest import Basetest
import loggingv1,sys

'''device initiliazation'''
#devicelist=adbmodule.initialization()
adbwrapper=adbwrapper()
dut=adbmodule.initializedut()
test=Basetest
time.sleep(7)
logname=[]
logcatname=[]
process=[]
testname='Test1'
advname='cstadv11'

logpath=adbmodule.createlogpath(testname)












	









