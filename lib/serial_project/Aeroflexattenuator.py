#!/usr/bin env python 3.4

import serial
import time
from serial import Serial
from Attenuator import Attenuator
from comdevice import COMdevice

class Aeroflexattenuator(Attenuator,COMdevice):
	def __init__(self,brand,maxattenuation,comport,baudrate,timeout):
		Attenuator.__init__(self,brand,maxattenuation)
		COMdevice.__init__(self,comport,baudrate,timeout)
		# self.brand=brand
		# self.maxattenuation=maxattenuation
		# self.comport=comport
		# self.baudrate=baudrate
		# self.timeout=timeout

	def readattenuation(self):
		if not self.isOpen():
			self.serialopen()
		command='ATTN?'
		result=self.sendcommand(command)
		self.close()
		if float(result)>0 and float(result)<95:
			return float(result)
		else:
			return None

	def setattenuation(self,attenuation):
		print(attenuation%0.5)
		if float(attenuation)>0 and float(attenuation)<=95 and (attenuation%0.5==0.0):
			if self.serialopen():
				command='ATTN '+str(attenuation)
				print(command)
				if self.settingconfirm(command):
					attenuation1=self.readattenuation()
					self.close()
					if attenuation1==float(attenuation):
						return True
					else:
						return False
		else:
			return False






