#!/usr/bin env python 3.4

class Solution:
    # @param {string} s
    # @return {integer}
    def lengthOfLongestSubstring(s):
        
        
        position=-1
        result=0
        dict1={}
        if len(s)>0:
        	dict1[s[0]]=position
        for i in range(len(s)):
        	#print('iteration for %d' %i)
        	if (s[i] in dict1) and (position<dict1[s[i]]):
        		position=dict1[s[i]]
        	#	print('position is %d' % position)
        	if i-position>result:
        		result=i-position
        	dict1[s[i]]=i
        return result


if __name__=="__main__":
	s='abba'
	c=Solution.lengthOfLongestSubstring(s)
	print(c)



