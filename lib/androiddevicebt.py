#!/usr/bin env python 3.4

from devicebt import devicebt

import sendcommand
import enums
import adbmodule,time


#global commandfile
#global objectpath


class Androiddevicebt(devicebt):

	global dut
	global BT
	global BLE
	global ble
	global client
	global server
	global peripheral
	global central
	global enable
	global serviceuuid
	global objectpath
	global commandfile
	global resultfile
	global Test1
	global advaddr
	#global deviceid
	
	commandfile='NotifyDUT.txt'
	resultfile='NotifyBM3.txt'
	tempresultfile='Tempresult.txt'
	objectpath='/data/'
	Test1='Test1'

	dut='DUT'
	BT='BT'
	#bt='bt'
	BLE='BLE'
	ble='ble'
	client='leclient'
	server='leserver'
	peripheral='peripheral'
	central='central'
	enable=1
	serviceuuid='serviceuuid'

	def __init__(self,deviceid,bt,btle,sequence,commandfile,objectpath):
		devicebt.__init__(self,os='Android',bt=True,btle=True)
		self.deviceid=deviceid
		self.bt=bt
		self.btle=btle
		self.sequence=sequence
		self.commandfile=commandfile
		self.objectpath=objectpath

	def creatlogfile(self,path):
		name=self.logname()
		name1=path+'\\'+name
		try:
			file1=open(name1,'a')
			file1.write('%s Started Execution\n' % Test1)
			file1.close()
			self.logfile=name1
			return name1
		except:
			print('could not generate log file')
			sys.exit(0)

	def createtemplog(self):
		name=tempresultfile
		try:
			file1=open(name,'w')
			file1.close()
		except:
			print('could not generate temp log')
			sys.exit(0)

	def logname(self):
		name=self.deviceid+'_DUT'+str(self.sequence)+'_execution'+'.txt'
		return name

	def logcatname(self):
		name=self.deviceid+'_DUT'+str(self.sequence)+'_logcat'+'.txt'
		return name

	def writetolog(self,command,filename,result,temp):
		if temp=0:
			option='a'
		elif temp=1:
			option='w'
		try:
			with open(filename,option) as f:
				f.write('Executing '+self.deviceid+' '+command+'\n')
				f.write(result+'\n')
				f.close()
		except:
			print('could not write to the log file')



	def executing(self,command,filename):
		sendcommand.sendcommand(command,commandfile)
		adbmodule.adbpush(self.deviceid,commandfile,objectpath)
		t=sendcommand.readresult(self.deviceid,self.objectpath,resultfile,command)
		if t[0]:
			result=self.deviceid+' '+command+' : '+'PASS'
			print(result)
		else:
			result=self.deviceid+' '+command+' : '+'FAIL'
			print(result)
		self.writetolog(command,filename,result,temp=0)
		self.writetolog(command,tempresultfile,result,temp=1)
		self.advaddr=t[1]
		time.sleep(1)

	'''initialization'''
	def turnonBT(self):
		command1='enableBT'
		command=' '.join([dut,command1])
		#logfile=self.creatlogfile(adbmodule.createlogpath(Test1))
		self.executing(command,self.logfile)
		

	def turnonLE(self):
		command1='enableLE'
		command=' '.join([dut,command1])
		#logfile=self.creatlogfile(adbmodule.createlogpath(Test1))
		self.executing(command,self.logfile)

	'''pairing'''
	def autoacceptpairingrequest(self,enable):
		command1='autoacceptnextpairingrequest'
		command=' '.join([dut,BT,command1,enable])
		self.executing(command,self.logfile)


	'''setname'''
	def setname(self,serial,name):
		command1='setname'
		command=' '.join([dut,str(serial),BT,command1,name])
		self.executing(command,self.logfile)

	'''leclient command'''
	def scanforname(self,serial,name):
		command1='scanfordevicename'
		command=' '.join([dut,str(serial),ble,client,command1,name])
		self.executing(command,self.logfile)
		
			

	def lescan(self,serial,ble,deviceaddr):
		command1='startscan'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(command,self.logfile)


	def connect(self,serial,deviceaddr):
		command1='connect'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(command,self.logfile)

	def discoverservices(self,serial,deviceaddr):
		command1='discoverservices'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
		self.executing(command,self.logfile)

	def writedescriptor(self,serial,deviceaddr,deviceid,UUID16bit,Characteristic,Descriptor,operation1,writedata):
		command1='writedescriptor'
		command=' '.join([dut,str(serial),ble,client,command1,deviceaddr,str(UUID16bit),str(Characteristic),str(Descriptor),str(operation1),str(writedata)])
		self.executing(command,self.logfile)

	'''leserver command'''

	def configurenewservicewithdatalength(self,serial,ble,deviceid,datalength):
		command1='configurenewservicewithdatalength'
		command=' '.join([dut,str(serial),ble,server,command1,str(datalength)])
		self.executing(command,self.logfile)

	'''timevalue in ms'''
	def setnotificationinterval(self,serial,deviceid,timevalue):
		command1='setnotificationinterval'
		command=' '.join([dut,str(serial),server,command1,str(timevalue)])
		self.executing(command,self.logfile)

	'''advertising'''
	def startbuildadvertiser(self,instance):
		command1='startbuildingnewadv'
		command=' '.join([dut,BLE,peripheral,command1,str(instance)])
		self.executing(command,self.logfile)


	def addadvdataUUID(self,UUID,instance):
		command1="addadvdata"
		command=' '.join([dut,BLE,peripheral,command1,str(instance),serviceuuid,UUID])
		self.executing(command,self.logfile)


	def setadvsetting(self,instance,advmode,advpower,connectable,timeout):
		command1='setadvsettings'
		command=' '.join([dut,BLE,peripheral,command1,str(instance),str(advmode),str(advpower),str(timeout),connectable])
		self.executing(command,self.logfile)


	def buildadvertiser(self,instance):
		command1='buildadv'
		command=' '.join([dut,BLE,peripheral,command1,str(instance)])
		self.executing(command,self.logfile)


	def startadvertising(self,instance):
		command1='startadv'
		command=' '.join([dut,BLE,peripheral,command1,str(instance)])
		self.executing(command,self.logfile)


	def stopadvertising(self,instance):
		command1='stopadv'
		command=' '.join([dut,BLE,peripheral,command1,instance])
		self.executing(command,self.logfile)

	def advertisingwithname(self,serial,instance,enable):
		command1='includedevicename'
		command=' '.join([dut,str(serial),ble,peripheral,'addadvdata',str(instance),command1,str(enable)])
		self.executing(command,self.logfile)
		


