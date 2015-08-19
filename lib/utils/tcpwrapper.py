#!/usr/bin env python 3.4

import serial
from serial import Serial
import socket,logging,time
from enum import Enum

logging.basicConfig(level=logging.INFO)

class IPaddress(Enum):
	Localhost='127.0.0.1'

class Tcpwrapper:
	def __init__(self,sock=None,logger=None):
		if sock is None:
			self.sock=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
		else:
			self.socck=sock
		self.logger=logger

	def connect(self,host,port):
		try:
			self.sock.connect((host,port))
			self.logger.info("connected to the TCP port")
		except socket.error as e1:
			self.logger.error("could not connect to tcp port"+str(e1))
			exit()

	def senddata(self,data):
		try:
			self.sock.sendall(data)
			self.logger.info('sended the data from TCP port')
		except socket.error as e:
			self.logger.info("could not send data "+str(e))
			exit()

	def bind(self,host,port):
		try:
			self.sock.bind((host,port))
			self.logger.info("bind the host and port")
		except socket.error as e:
			self.logger.error("could not bind "+str(e))

	def receivedata(self,timeout=2):
		self.sock.setblocking(0)
		totaldata=[]
		data=''
		begin=time.time()
		while True:
			if totaldata and time.time()-begin>timeout:
				break
			elif time.time()-begin>timeout*2
				break
			try:
				data=self.sock.recv(8192)
				if data:
					totaldata.append(data)
					begin=time.time()
				else:
					time.sleep(0.1)
			except socket.error as e:
		return ''.join(totaldata)


	def serverlisten(self,time):
		self.sock.listen(time)
		while True:
			conn.addr=self.sock.accept()
			self.logger.info('conneted with '+addr[0]+':'+str(addr[1]))
			data=conn.recv(1024)
			result1=data.decode('utf-8')
			conn.close()
			break
		return result1

	def closesocket(self):
		self.sock.close()









