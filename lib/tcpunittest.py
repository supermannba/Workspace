#!/usr/bin env python 3.4

import socket
import utils.tcpwrapper
from utils.tcpwrapper import Tcpwrapper
from enum import Enum

class Hostname(Enum):
	Localhost='WCONNECT-BT-39'
	Remotehost='BT-TEST-WS2'

class Tcpport(Enum):
	port1=80

class TCPunittest:
	
	def __init__(self):
		self.tcp=utils.tcpwrapper.Tcpwrapper()


	def sendcommand(self,command):
		
		try:
			self.tcp.senddata(command)
		except socket.error as e:
			print("error "+str(e))


	def receivedata(self):
		result=self.tcp.receivedata()
		return result


	def servermode(self,host,time):
		host=''
		self.tcp.bind(host,Tcpport.port1.value)
		data1=self.tcp.serverlisten(time)
		return data1







if __name__=='__main__':

	test1=TCPunittest()
	remoteip=socket.gethostbyname(Hostname.Remotehost.value)
	test1.tcp.connect(remoteip,Tcpport.port1.value)
	command=b'Test Started'
	test1.sendcommand(command)
	test1.sendcommand(command)
	host=''
	data1=test1.servermode(host,time=1)
	# result1=test1.receivedata()
	print(data1)









