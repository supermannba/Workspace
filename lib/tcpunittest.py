#!/usr/bin env python 3.4

import socket,time
import utils.tcpwrapper
from utils.tcpwrapper import Tcpwrapper
from enum import Enum
import time

class Hostname(Enum):
	Localhost='WCONNECT-BT-39'
	Remotehost='BT-TEST-WS2'

class Tcpport(Enum):
	port1=80
	port2=10000

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


	def servermode(self,host,time,port):
		# host=''
		self.tcp.bind(host,port)
		data1=self.tcp.serverlisten(time)
		return data1


def main():

	# test1=TCPunittest()
	# remoteip=socket.gethostbyname(Hostname.Remotehost.value)
	# test1.tcp.connect(remoteip,Tcpport.port1.value)
	# while True:
	# 	data=test1.tcp.sock.recv(100)
	# 	result=data.decode('utf-8')
	# 	print(result)
	# 	if result=='end':
	# 		break

	# command=b'Test Started'
	# command1=b'end'
	# test1.sendcommand(command)
	# time.sleep(5)
	#G test1.sendcommand(command1)
	
	# host=''
	# data=test1.tcp.sock.recv(100)
	# print(data)

	# test1.tcp.sock.shutdown(1)
	# test1.tcp.sock.close()


	test1=TCPunittest()
	print(test1.tcp.sock)
	test1.tcp.sock.bind(('',80))

if __name__=='__main__':main()

	







