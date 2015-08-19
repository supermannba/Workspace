#!/usr/bin env python 3.4

from comdevice import COMdevice

class Attenuator(object):
	def __init__(self,brand,maxattenuation):
		self.brand=brand
		self.maxattenuation=maxattenuation
		
	def setattenuation(self,attenuation):
		pass

	def readattenuation(self):
		pass

	def setattenuationsize(self):
		pass

	def readattenuationsetting(self):
		pass

	def increase(self,attenuation):
		pass

	def decrease(self,attenuation):
		pass


	def clearerror(self):
		pass

	def readerror(self):
		pass



