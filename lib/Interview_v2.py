#!/usr/bin env python 3.4

class Solution:

	def encode(s):
		if len(s)<2:
			return s+str(len(s))
		result=''
		i=0
		number=1
		while i<len(s)-1:
			result=result+s[i]
			while s[i+1]==s[i]:
				number=number+1
				i=i+1
				if i==len(s)-1:
					break			
			result=result+str(number)
			number=1
			if i==len(s)-1:
				break
			i=i+1
		if s[len(s)-1] is not s[len(s)-2]:
			result=result+s[len(s)-1]+str(1)
		return result

	def decode(s):
		if len(s)<1:
			return s
		result=''
		i=0
		while i<len(s)-1:
			for j in range(int(s[i+1])):
				result=result+s[i]
			i=i+2
		return result


if __name__=='__main__':
	c=Solution
	b=c.encode('ab')
	print(b)
	d=c.decode(b)
	print(d)


