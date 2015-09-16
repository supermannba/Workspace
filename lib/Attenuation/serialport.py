#!/usr/bin env python 3.4

import os
import serial,time
from serial import Serial
import re

global ERROR
ERROR='invalid cmd'

class Serialport(Serial):
	def __init__(self,port,baudrate,timeout):
		Serial.__init__(self)
		self.port=port
		self.baudrate=baudrate
		self.timeout=timeout
		self.bytesize = serial.EIGHTBITS #number of bits per bytes
		self.parity = serial.PARITY_NONE #set parity check: no parity
		self.stopbits = serial.STOPBITS_ONE #number of stop bits
		self.xonxoff=False
		self.rtscts=False
		self.dsrdtr=False
		self.writeTimeout=2


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

if __name__=='__main__':
	
	serial1=Serialport(19,115200,1)
	print(serial1)
	try:
		serial1.open()
	except Exception as e:
		print('error open serial port'+str(e))
		exit()
	command='*TST?'
	result=serial1.sendcommand(command)
	serial1.close()
	print(result)



