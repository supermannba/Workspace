#!/usr/bin env python 3.4

from devicebt import devicebt

import sendcommand
import enums
import adbmodule,time


#global commandfile
#global objectpath


class Androiddevicebt(devicebt):

	global dut
	global objectpath
	global commandfile
	global resultfile
	#
	commandfile='NotifyDUT.txt'
	resultfile='NotifyBM3.txt'
	objectpath='/data/'
	

	dut='DUT'
	BT='BT'
	BLE='BLE'
	ble-'ble'
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

	def writetolog(self,deviceid,command,filename,result):
		try:
			with open(filename,'w') as f:
				f.write('Executing '+deviceid+' '+command)
				f.write(result)
				f.close()
		except:
			print('could not write to the log file')

	def executing(self,deviceid,command,filename):
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(deviceid,commandfile,objectpath)
		t=sendcommand.readresult(deviceid,objectpath,resultfile,command)
		if t:
			result=command+' : '+'PASS'
			print(result)
		else:
			result=command+' : '+'FAIL'
			print(result)
		writetolog(deviceid,command,filename,result)
		time.sleep(1)

	'''initialization'''
	def turnonBT(self,deviceid):
		command1='enableBT'
		command=' '.join([dut,command1])
		self.executing(deviceid,command)
		

	def turnonLE(self,deviceid):
		command1='enableLE'
		command=' '.join([dut,command1])
		self.executing(deviceid,command)

	'''pairing'''
	def autoacceptpairingrequest(self,deviceid,enable):
		command1='autoacceptnextpairingrequest'
		command=' '.join([dut,BT,command1,enable])
		self.executing(deviceid,command)

	'''setname'''
	def setname(self,deviceid,name):
		command1='setname'
		command=' '.join([dut,BT,command1,name])
		self.executing(deviceid,command)

	'''leclient command'''
	def lescan(self,serial,ble,deviceaddr,deviceid):
		command1='startscan'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(deviceid,command)

	def connect(self,serial,deviceaddr,deviceid):
		command1='connect'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(deviceid,command)

	def discoverservices(self,serial,deviceaddr,deviceid):
		command1='discoverservices'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(deviceid,command)

	def writedescriptor(self,serial,deviceaddr,deviceid,UUID16bit,Characteristic,Descriptor,operation1,writedata):
		command1='writedescriptor'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr,UUID16bit,Characteristic,Descriptor,operation1,writedata])
		self.executing(deviceid,command)

	'''leserver command'''

	def configurenewservicewithdatalength(self,serial,ble,deviceid,datalength):
		command1='configurenewservicewithdatalength'
		command=' '.join([dut,str(serial),ble,server,command1,str(datalength)])
		self.executing(deviceid,command)

	'''timevalue in ms'''
	def setnotificationinterval(self,serial,deviceid,timevalue):
		command1='setnotificationinterval'
		command=' '.join([dut,str(serial),server,command1,str(timevalue)])

	def startbuildadvertiser(self,instance,deviceid):
		command1='startbuildadvertiser'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		self.executing(deviceid,command)

	def addadvdataUUID(self,UUID,instance,deviceid):
		command1="addadvdata"
		command=' '.join([dut,BLE,peripheral,command1,UUID,instance])
		self.executing(deviceid,command)

	def setadvsetting(self,instance,advmode,advpower,connectable,timeout,deviceid):
		command1='setadvsetting'
		command=' '.join([dut,BLE,peripheral,command1,instance,advmode,advpower,timeout,connectable])
		self.executing(deviceid,command)

	def buildadvertiser(self,instance,deviceid):
		command1='buildadvertiser'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		self.executing(deviceid,command)

	def startadvertising(self,instance,deviceid):
		command1='startadv'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		self.executing(deviceid,command)

	def stopadvertising(self,instance,deviceid):
		command1='stopadv'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		self.executing(deviceid,command)

		


