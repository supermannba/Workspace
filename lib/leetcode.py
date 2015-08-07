#!/usr/bin env python 3.4

class Solution:
    # @param {string} s
    # @return {integer}
    def lengthOfLongestSubstring(s):
        
        a=0
        b=1
        max1=0
        if len(s)==0:
            return 0
        elif len(s)==1:
            return 1
        while a<(len(s)-1):
        	if s[b] not in s[a:b]:
        		b+=1
        	else:
        		if b-a>=max1:
        			max1=b-a
        		a=s[a:b].index(s[b])+a+1
        		b=a+1
        	if b>(len(s)-1):
        	    break
        if b-a>max1:
            max1=b-a
        		
        	
        return max1

if __name__=='__main__':
	s='aaaabcdedaaaaabcdeghijkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadhldd'
	c=Solution.lengthOfLongestSubstring(s)
	print(c)
