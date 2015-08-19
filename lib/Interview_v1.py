#!/usr/bin env python 3.4

class Solution:

	def getmostcartime(s):
		dict1={x:0 for x in range(1,10)}
		for i in range(len(s)):
			for j in range(1,10):
				if int(s[i][0]) in range(8+j,9+j):
					for k in range(j,10):
						dict1[k]+=1
				if int(s[i][1]) in range(8+j,9+j):
					for k in range(j,10):
						dict1[k]-=1
		print(dict1)
		return max(dict1,key=dict1.get)



if __name__=='__main__':
	s=[
	[9.4,15.4],
	[9.5,16,7],
	[9.7,17.5],
	[10.1,16.7],
	[10.3,17.4],
	[11.3,16.7],
	[11.5,17.5],
	[12.1,17.9]
	]

	c=Solution
	print(c.getmostcartime(s))

