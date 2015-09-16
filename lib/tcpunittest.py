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

	test1=TCPunittest()
	remoteip=socket.gethostbyname(Hostname.Remotehost.value)
	test1.tcp.connect(remoteip,Tcpport.port1.value)
	command=b'Test Started'
	command1=b'end'
	# test1.sendcommand(command)
	test1.sendcommand(command1)
	#time.sleep(2)
	host=''
	#data1=test1.servermode(host,time=1,port=100)
	# result1=test1.receivedata()
	# test1.tcp.bind(host,Tcpport.port1.value)
	# print("listening to new request")
	# result1=test1.receivedata()
	# print(result1)
	data=test1.tcp.sock.recv(100)
	print(data)

	test1.tcp.sock.shutdown(1)
	test1.tcp.sock.close()


	# test2=TCPunittest()
	# test2.servermode(host,time=1,port=Tcpport.port1.value)
	# test2.tcp.sock.close()
	# test2.tcp.bind(host,Tcpport.port1.value)
	# test2.tcp.sock.listen(1)
	# while True:
	# 	conn,addr=test2.tcp.sock.accept()
	# 	data=conn.recv(1024)
	# 	result1=data.decode("utf-8")
	# 	conn.close()
	# 	break
	# print(data)


if __name__=='__main__':main()

	







