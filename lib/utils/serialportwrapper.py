#!/usr/bin env python 3.4

from serial import Serial
import serial,time,logging
from enum import Enum

logging.basicConfig(level=logging.INFO)

class responseevent(Enum):
	Setting="Command Executed Successful"
	ERROR='invalid cmd'

class commandmode(Enum):
	LINE=1
	GROUP=2
	VERIFY=3

class serialport(Serial):
	def __init__(self,comport,baudrate,timeout,logger=None):
		super().__init__()
		self.port=comport
		self.baudrate=baudrate
		self.timeout=timeout
		self.bytesize = serial.EIGHTBITS #number of bits per bytes
		self.parity = serial.PARITY_NONE #set parity check: no parity
		self.stopbits = serial.STOPBITS_ONE #number of stop bits
		self.xonxoff=False
		self.rtscts=False
		self.dsrdtr=False
		self.writeTimeout=2
		self.logger=logger
	
	def serialportopen(self):
		if not self.isOpen():
			try:
				self.open()
				self.logger.info('serial port open successful')
				return True
			except Exception as e:
				self.logger.error('error open serial port'+str(e))
				return False
				

	def serialportclose(self):
		if self.isOpen():
			try:
				self.close()
				self.logger.info('serial port closed successful')
			except Exception as e:
				self.logger.error('error close serial port'+str(e))
				exit()

	def sendcommand(self,command,mode):
		result=[]
		if self.isOpen():
			self.logger.info("ready to send command")
			try:
				self.flushInput()
				self.flushOutput()
				time.sleep(0.5)
				try:
					self.write(command.encode('ascii')+b'\r\n')
					self.logger.info("write command: %s" % command)
				except Exception as e:
					self.logger.error("could not send command "+str(e))
				'''receiving result'''
				while True:
					response=self.readline()
					if command in response.decode('ascii'):
						response=self.readline()
						if responseevent.ERROR not in response.decode('ascii'):
							result.append((response.decode('ascii').split('\r\n'))[0])
							if mode==commandmode.LINE.value:
								if result[0]=='':
									return "Command Executed Successful"
							elif mode==commandmode.VERIFY.value:
								if result[0]!='':
									return result[0]
							elif mode==commandmode.GROUP.value:
								i=0
								response=self.readline()
								resutl1=(response.decode('ascii').split('\r\n'))[0]
								while result1!='':
									result.append(result1)
									response=self.readline()
									resutl1=(response.decode('ascii').split('\r\n'))[0]
								return result
						else:
							self.logger.error("Invalid Commmand")
							result[0]='Invalid Command'
							return result[0]
			except Exception as e1:
				self.logger.error("error communication with serialport"+str(e1))
		else:
			self.logger.error("could not open the serial port")

	def settingconfirm(self,command):
		if not self.isOpen():
			self.logger.error("serial port is not open")
		result=self.sendcommand(command,mode=1)
		if result==responseevent.Setting:			
			self.logger.info("setting value successful")
			return True
		else:			
			self.logger.error("setting value fail")
			return False



	def clearerrorstatus(self):
		commasnd='*CLS'
		result=self.settingconfirm(command,mode=1)
		if result:
			return True
		else:
			return False

	def selftest(self):
		command='*TST?'
		if self.serialopen():
			result=self.sendcommand(command,mode=3)
			if result=='0':
				return True
			else:
				return False
		else:
			return False

	






