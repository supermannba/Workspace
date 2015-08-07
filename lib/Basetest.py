#!/usr/bin env python 3.4

import os
import adbmodule
import loggingv1
import androiddevicebt
from androiddevicebt import Androiddevicebt

'''unit testing frame'''

class Basetest(object):

	def initialize(deviceid,dut1=Androiddevicebt):
		dut1.turnonBT(deviceid)
		dut1.turnonLE(deviceid)

	def advertising(self,deviceid,instance,UUID,advmode,advpower,connectable,timeout,dut1=Androiddevicebt):
		dut1.setadvsetting(instance,advmode,abvpower,connectable,timeout,deviceid)
		dut1.startbuildadvertiser(instance,deviceid)
		dut1.addadvdataUUID(UUID,instance,deviceid)
		dut1.buildadvertiser(instance,deviceid)
		dut1.startadvertising(instance,deviceid)

	def scanandconnect(self,deviceid,serial,deviceaddr,dut1=Androiddevicebt):
		dut1.lescan(serial,deviceaddr,deviceid)
		dut1.connect(serial,deviceaddr,deviceid)






	



