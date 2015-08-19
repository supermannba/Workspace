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

	def readthesetting(self,command):
		if not self.isOpen():
			self.serialopen()
		result=self.sendcommand(command)
		self.close()
		if float(result)>=0 and float(result)<=95.5:
			return float(result)
		else:
			return None

	def readattenuation(self):
		command='ATTN?'
		result=self.readthesetting(command)
		return result
		
	def setattenuation(self,attenuation):
		command='ATTN '+str(attenuation)
		result=self.setattenuationsetting(command,attenuation)
		return result
		
	def readattenuationsize(self):
		command='STEPSIZE?'
		result=self.readthesetting(command)
		return result

	def setattenuationsetting(self,command,setting):
		if setting>=0 and setting<=95.5 and (setting%0.5==0.0):
			if not self.isOpen():
				self.serialopen()
			if self.settingconfirm(command):
				setting1=self.readthesetting(command)
				self.close()
				if setting1==float(setting):
					return True
				else:
					return False
			else:
				print('setting fail')
				return False
		else:
			return False

	def setattenuationsize(self,size):
		command='STEPSIZE '+str(size)
		result=self.setattenuationsetting(command,size)
		return result

	def increment(self):
		command='INCR'
		if self.settingconfirm(command):
			self.closecom
		attenuation=self.readattenuation()
		size=self.readattenuationsize()
		summary=attenuation+size
		if summary>95.5:
			summary=95.5
		result=self.readattenuation()
		if float(summary)==float(result):
			return True
		else:
			return False

	def decrement(self):
		command='DECR'
		if self.settingconfirm(command):
			self.closecom
		attenuation=self.readattenuation()
		size=self.readattenuationsize()
		summary=attenuation-size
		if summary<0:
			summary=0.0
		result=self.readattenuation()
		if float(summary)==float(result):
			return True
		else:
			return False

	def fade(self,start,stop,interval):
		if start>=0 and start<=95.5:
			if stop>=0 and stop<=95.5:
				if interval>0 and interval<=10000:
					command='FADE '+str(start)+' '+str(stop)+' '+str(interval)
					if self.settingconfirm():
						self.closecom
						return True
					else:
						return False
				else:
					return False
			else:
				return False
		else:
			return False

	def fadeshow(self,start,stop,interval):
		if start>=0 and start<=95.5:
			if stop>=0 and stop<=95.5:
				if interval>0 and interval<=10000:
					command='FADE? '+str(start)+' '+str(stop)+' '+str(interval)
					if self.settingconfirm():
						self.closecom
						return True
					else:
						return False
				else:
					return False
			else:
				return False
		else:
			return False

	def rfconfig(self):
		command='RFCONFIG?'
		if not self.isOpen():
			self.serialopen()
		result=self.sendcommand(command)
		self.close()
		if '4205' in result:
			return result
		else:
			return None







		
		





				









