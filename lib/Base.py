 #!/usr/bin env python 3.4


global ass
ass=5

class Base(object):
 	def __init__(self,a,b):
 		self.a=a
 		self.b=b

 	def plus(self,a,b):
 		return a+b

 	global victory