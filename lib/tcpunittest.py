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
		remoteip=self.tcp.sock.gethostbyname(Hostname.Remotehost.value)
		try:
			self.tcp.connect(remoteip,Tcpport.port1.value)
		except socket.error as e:
			print("error "+str(e))

		try:
			self.tcp.senddata(command)
		except socket.error as e:
			print("error "+str(e))


	def receivedata(self):
		result=self.tcp.receivedata()
		return result


if __name__=='__main__':

	test1=TCPunittest()

	command=b'Test Started'

	test1.sendcommand(command)
	resutl1=test1.receivedata()
	








