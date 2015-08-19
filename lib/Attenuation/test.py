#!/usr/bin env python 3.4
import logging

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger(__name__)


class A(object):
	def __init__(self,a):
		self.a=a

	def print1(self,b):
		logger.info("A class created")
		print(b)


class B(object):
	def __init__(self,b):
		self.b=b

	def print2(self):
		logger.info("B class generated")
		print('is s')

class C(A,B):
	def print3(self):
		logger.info("combine class created")
		print('adfsadfadfa')

		

if __name__=='__main__':
	abc=C(2)
	abc.print1('d')
	abc.print2()


