#!/usr/bin env python 3.4

import socket,logging,time
from enum import Enum

logging.basicConfig(level=logging.INFO)

class IPaddress(Enum):
	Localhost='127.0.0.1'

class Tcpwrapper:
	def __init__(self,sock=None):
		if sock is None:
			self.sock=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
		else:
			self.sock=sock
		self.logger=logging.getLogger(__name__)

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

	def receivedata(self,conn,timeout=2):
		self.sock.setblocking(0)
		totaldata=[]
		data=''
		begin=time.time()
		while True:
			if totaldata and time.time()-begin>timeout:
				break
			elif time.time()-begin>timeout*2:
				break
			try:
				data=conn.recv(1024)
				if data:
					totaldata.append(data.decode("utf-8"))
					begin=time.time()
				else:
					time.sleep(0.5)
			except socket.error as e:
				self.logger.error("receive data error"+str(e))
		print(totaldata)
		return ''.join(totaldata)

	def serverlisten(self,time1):
		self.sock.listen(time1)
		while True:
			conn,addr=self.sock.accept()
			if conn:
				self.logger.info('conneted with '+addr[0]+':'+str(addr[1]))
				command=b'lalala'
				command1=b'end'
				conn.send(command)
				time.sleep(5)
				conn.send(command1)
				# while True:
					# data=conn.recv(1024)
					# if data:
						# result1=data.decode("utf-8")
						# if "end" in result1:
							# break;
						# print(result1)
					#conn.sendall(data)
				break
		conn.close()	
	
		
		



	def closesocket(self):
		self.sock.close()









