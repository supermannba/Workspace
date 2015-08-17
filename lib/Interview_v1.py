#!/usr/bin env python 3.4

class Solution:

	def getmostcartime(s):
		dict1={x:0 for x in range(1,10)}
		for i in len(s):
			if s[i][1]>9 and s[i][1]<10:
				dict1[1]+=1
			elif s[i][1]>10 and s[i][1]<11:
				dict1[2]+=1
			elif s[i][1]>11 and s[i][1]<12:
				dict1[3]+=1
			elif s[i][1]>12 and s[i][1]<13:
				dict1[4]+=1
			elif s[i][1]>13 and s[i][1]<14:
				dict1[5]+=1
			elif s[i][1]>14 and s[i][1]<15:
				dict1[6]+=1
			elif s[i][1]>15 and s[i][1]<16:
				dict1[7]+=1
			elif s[i][1]>16 and s[i][1]<17:
				dict1[8]+=1
			elif s[i][1]>17 and s[i][1]<18:
				dict1[9]+=1
		
			
