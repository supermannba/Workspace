#!/usr/bin env python 3.4

import Base

def sum(x,y):
	if x==y:
		return True,'1'
	else:
		return False,'1'

b=sum(3,3)
print(b)
if b[0]:
	print('yeah')