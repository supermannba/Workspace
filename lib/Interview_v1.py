#!/usr/bin env python 3.4

class Solution:

	def getmostcartime(s):
		dict1={x:0 for x in range(1,10)}
		for i in range(len(s)):
			for j in range(1,10):
				if int(s[i][0]) in range(8+j,9+j):
					for k in range(j,10):
						dict1[k]+=1
		for i in range(len(s)):
			for j in range(1,10):
				if int(s[i][1]) in range(8+j,9+j):
					for k in range(j,10):
						dict1[k]=dict1[k]-1
		result=max(dict1,key=dict1.get)
		return result

if __name__=='__main__':
	s=[
	[9.4,16.5],
	[9.5,17.5],
	[9.8,16.9],
	[10.3,14.3],
	[10.5,15.6],
	[10.7,17.6],
	[11,17.5]
	]
	c=Solution
	b=c.getmostcartime(s)
	print(b)






			
