#!/usr/bin env python 3.4

class A(object):
	def __init__(self,a):
		self.a=a

	def print1(self,b):
		print(b)


class B(object):
	def __init__(self,b):
		self.b=b

	def print2(self):
		print('is s')

class C(A,B):
	def print3(self):
		print('adfsadfadfa')

		

if __name__=='__main__':
	abc=C(b=3)
	abc.print1('d')
	abc.print2()


