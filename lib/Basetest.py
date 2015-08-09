#!/usr/bin env python 3.4

import os,time,enums
import adbmodule
import loggingv1
import androiddevicebt
from androiddevicebt import Androiddevicebt

'''unit testing frame'''

class Basetest(object):

	def initialize(dut1=Androiddevicebt):
		dut1.turnonBT()
		dut1.turnonLE()

	# def advertising(self,deviceid,instance,UUID,advmode,advpower,connectable,timeout,dut1=Androiddevicebt):
	# 	dut1.setadvsetting(instance,advmode,abvpower,connectable,timeout,deviceid)
	# 	dut1.startbuildadvertiser(instance,deviceid)
	# 	dut1.addadvdataUUID(UUID,instance,deviceid)
	# 	dut1.buildadvertiser(instance,deviceid)
	# 	dut1.startadvertising(instance,deviceid)

	def advertising(serial,instance,advmode,advpower,connectable,timeout,name,UUID=enums.UUID.UUID0,dut1=Androiddevicebt):
		dut1.setname(serial,name)
		dut1.startbuildadvertiser(instance)
		dut1.advertisingwithname(serial,instance,enable)
		dut1.setadvsetting(instance,advmode,advpower,connectable,timeout)
		dut1.buildadvertiser(instance)
		dut1.startadvertising(instance)

	def scanandconnect(self,deviceid,serial,deviceaddr,dut1=Androiddevicebt):
		dut1.lescan(serial,deviceaddr,deviceid)
		dut1.connect(serial,deviceaddr,deviceid)

	






	



