#!/usr/bin env python 3.4

from devicebt import devicebt

import sendcommand

import adbmodule,time


#global commandfile
#global objectpath


class Androiddevicebt(devicebt):

	

	global dut
	global objectpath
	global commandfile
	global resultfile
	#global objectpath
	commandfile='NotifyDUT.txt'
	resultfile='NotifyBM3.txt'
	objectpath=r'/data'

	dut='DUT'
	BT='BT'
	BLE='BLE'
	client='client'
	server='leserver'
	peripheral='peripheral'
	central='central'


	def __init__(self,deviceid,bt,btle,commandfile,objectpath):
		devicebt.__init__(self,os='Android',bt=True,btle=True)
		self.deviceid=deviceid
		self.bt=bt
		self.btle=btle
		self.commandfile=commandfile
		self.objectpath=objectpath

	def turnonBT(self,deviceid):
		command1='enableBT'
		command=' '.join([dut,command1])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)
		

	def turnonLE(self,deviceid):
		command1='enableLE'
		command=' '.join([dut,command1])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

	'''leclient command'''
	def lescan(self,serial,deviceaddr,deviceid):
		command1='startscan'
		command=' '.join([dut,str(serial),client,command1,deviceaddr])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

	def connect(self,deviceaddr,deviceid):
		command1='connect'
		command=' '.join([dut,str(serial),client,command1,deviceaddr])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)


	'''leserver command'''
	def startbuildadvertiser(self,instance,deviceid):
		command1='startbuildadvertiser'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

	def addadvdataUUID(self,UUID,instance,deviceid):
		command1="addadvdata"
		command=' '.join([dut,BLE,peripheral,command1,UUID,instance])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

	def buildadvdata(self,instance,deviceid):
		command1='buildadvertiser'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

	def setadvsetting(self,instance,adbmode,adbpower,connectable,timeout,advdeviceid):
		command1='setadvsetting'
		command=' '.join([dut,BLE,peripheral,command1,instance,advmode,adbpower,timeout,connectable])
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		sendcommand.readresult(deviceid,objectpath,resultfile)
		time.sleep(1)

		


