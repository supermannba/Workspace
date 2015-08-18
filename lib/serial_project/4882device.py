#!/usr/bin env python 3.4

from serial import Serial

class COMdevice(Object):
	def __init__(self,comport,baudrate,timeout):
		self.comport=comport
		self.baudrate=baudrate
		self.timeout=timeout

	def establishcomconnection(self):
		serial1=Serialport(self.comport,self.baudrate,self.timeout)
		try:
			serial1.open()
		except Exception as e:
			print('error open serial port'+str(e))
			exit()
		return serial1

	

