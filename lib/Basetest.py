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

	def advertising(serial,instance,advmode,advpower,connectable,timeout,name,remotehost=enums.Hostname.Localhost.value,notify=False,UUID=enums.UUID.UUID0.value,dut1=Androiddevicebt):
		for i in range(instance):
			dut1.setname(serial,name)
			dut1.startbuildadvertiser(i+1)
			dut1.advertisingwithname(serial,(i+1),enable)
			dut1.addadvdataUUID(UUID,(i+1))
			dut1.setadvsetting((i+1),advmode,advpower,connectable,timeout)
			dut1.buildadvertiser(i+1)
			dut1.startadvertising(i+1)
		if notify==True:
			sendcommand.notifyremote(enums.Filename.notifyfile.value,host=remotehost)
		else:
			print('advertisng instance %d finish\n' % instance)

	def advertising1(serial,instance,advmode,advpower,connectable,timeout,name,remotehost=enums.Hostname.Localhost.value,notify=False,UUID=enums.UUID.UUID0.value,dut1=Androiddevicebt):
		dfor i in range(instance):
			dut1.setname(serial,name)
			dut1.startbuildadvertiser(i+1)
			dut1.advertisingwithname(serial,(i+1),enable)
			dut1.addadvdataUUID(UUID,(i+1))
			dut1.setadvsetting((i+1),advmode,advpower,connectable,timeout)
			dut1.buildadvertiser(i+1)
			dut1.startadvertising(i+1)
		if notify:
			socket1=dut1.establishsocket()
			dut1.socketsenddata(socket1,enums.Tcpport.port1.value,remotehost)


	def scanandconnect(serial,advname,dut1=Androiddevicebt):
		dut1.scanforname(serial,advname)
		deviceaddr=dut1.advaddr
		dut1.connect(serial,deviceaddr)



	def scanandconnect1(serial,advname,checkdata=False,dut1=Androiddevicebt):
		execution=True
		if checkdata:
			execution=dut1.checkdata(enums.Tcpport.port1.value,enums.noticeevent.advertisingstart.value,time=10):
		if execution:
			dut1.scanforname(serial,advname)
			deviceaddr=dut1.advaddr
			dut1.connect(serial,deviceaddr)

	def writedescriptor(serial,UUID16bit,Characteristic,Descriptor,operation1,writedata,dut1=Androiddevicebt):
		dut1.discoverservices(serial,dut1.advaddr)
		dut1.writedescriptor(serial,dut1.advaddr,UUID16bit,Characteristic,Descriptor,operation1,writedata)
		
	






	



