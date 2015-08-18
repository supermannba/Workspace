#!/usr/bin env python 3.4

from serial import Serial
import serial,time

global Setting
global ERROR
Setting="Command Executed Successful"
ERROR='invalid cmd'

class COMdevice(Serial):
	def __init__(self,comport,baudrate,timeout):
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
	
	def serialopen(self):
		try:
			self.open()
			return True
		except Exception as e:
			print('error open serial port'+str(e))
			return False
			exit()

	def closecom(self):
		if self.isOpen():
			self.close()

	def sendcommand(self,command):
		if self.isOpen():
			print("communication is open")
			try:
				self.flushInput()
				self.flushOutput()
				time.sleep(0.5)
				numline=0
				self.write(command.encode('ascii')+b'\r\n')
				print("write data: %s" % command)
				
				while True:
					response=self.readline()
					if command in response.decode('ascii'):
						response=self.readline()
						if ERROR not in response.decode('ascii'):
							result=response.decode('ascii').split('\r\n')
							result1=result[0]
							if result1=='':
								return "Command Executed Successful"
						else:
							result1='Invalid Command'

						return result1
			except Exception as e1:
				print("error communication with "+str(e1))
		else:
			print("could not open the serial port")

	def settingconfirm(self,command):
		if not self.isOpen():
			try:
				self.open()
			except Exception as e:
				print('error open serial port'+str(e))
				exit()

		result=self.sendcommand(command)
		self.closecom
		if result==Setting:
			return True
		else:
			return False



	def clearerrorstatus(self):
		commasnd='*CLS'
		result=self.settingconfirm(command)
		if result:
			return True:
		else:
			return False

	def selftest(self):
		command='*TST?'
		if self.serialopen():
			result=self.sendcommand(command)
			if result='0':
				return True
			else:
				return False
		else:
			return False

	def errorcode(self):
		command='ERR?'
		pass






