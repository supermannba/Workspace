#!/usr/bin env python 3.4

import os,time,enums
import adbmodule
import loggingv1
import androiddevicebt
from androiddevicebt import Androiddevicebt

global enable
enable='true'
'''unit testing frame'''

class Basetest(object):

	def initialize(dut1=Androiddevicebt):
		dut1.turnonBT()
		dut1.turnonLE()

	def advertising(serial,instance,advmode,advpower,connectable,timeout,name,remotehost,notify=False,UUID=enums.UUID.UUID0.value,dut1=Androiddevicebt):
		dut1.setname(serial,name)
		dut1.startbuildadvertiser(instance)
		dut1.advertisingwithname(serial,instance,enable)
		dut1.addadvdataUUID(UUID,instance)
		dut1.setadvsetting(instance,advmode,advpower,connectable,timeout)
		dut1.buildadvertiser(instance)
		dut1.startadvertising(instance)
		if notify==True:
			sendcommand.notifyremote(enums.Filename.notifyfile.value,host=remotehost)
		else:
			print('advertisng instance %d finish\n' % instance)

	def scanandconnect(serial,advname,dut1=Androiddevicebt):
		dut1.scanforname(serial,advname)
		deviceaddr=dut1.advaddr
		dut1.connect(serial,deviceaddr)

	def writedescriptor(serial,UUID16bit,Characteristic,Descriptor,operation1,writedata,dut1=Androiddevicebt):
		dut1.discoverservices(serial,dut1.advaddr)
		dut1.writedescriptor(serial,dut1.advaddr,UUID16bit,Characteristic,Descriptor,operation1,writedata)
		
	






	



