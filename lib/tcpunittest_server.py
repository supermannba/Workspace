#!/usr/bin env python 3.4

import socket,logging
import utils.tcpwrapper
from utils.tcpwrapper import Tcpwrapper
from enum import Enum
import time

logging.basicConfig(level=logging.INFO)


class Hostname(Enum):
	Remotehost='WCONNECT-BT-39'
	Localhost='BT-TEST-WS2'

class Tcpport(Enum):
	port1=80
	port2=100

class TCPunittest:
	
	def __init__(self,logger=None):
		self.tcp=utils.tcpwrapper.Tcpwrapper()
		self.logger=logger


	def sendcommand(self,command):
		# remoteip=self.tcp.sock.gethostbyname(Hostname.Remotehost.value)
		# try:
		# 	self.tcp.connect(remoteip,Tcpport.port1.value)
		# except socket.error as e:
		# 	print("error "+str(e))

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

def main():
	test1=TCPunittest()
	remoteip=socket.gethostbyname(Hostname.Remotehost.value)
	# test1.tcp.connect(remoteip,Tcpport.port1.value)
	command=b'Test Started'
	# test1.sendcommand(command)
	# resutl1=test1.receivedata()
	# print(result1)
	host=''
	# test1.tcp.bind(host,Tcpport.port1.value)
	test1.servermode(host,time=1)
	#print(data1)
	time.sleep(5)
	test1.tcp.connect(remoteip,Tcpport.port1.value)
	test1.sendcommand(command)
	






if __name__=='__main__':main()

	
	










