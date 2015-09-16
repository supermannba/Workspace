class Solution:
    # @param {string} a a number
    # @param {string} b a number
    # @return {string} the result
    def addBinary(a, b):
        # Write your code here
        print(a)
        print(b)
        print(a[3])
        if len(a)>=len(b):
            short=b
            long1=a
        else:
            short=a
            long1=b
        result=''
        i=0
        plus=0
        while i<len(short):
            
            if long1[i]=='1' and short[i]=='1':
                result=str(0+plus)+result
                plus=1
            elif long1[i]=='0' and short[i]=='0':
                result=str(plus)+result
                plus=0
            else: 
                print(result)
                print('went here')
                print(long1[0])
                print(short[0])
                print('plus is %d' % plus)
                if plus==0:
                    result=str(1)+result  
                else:
                    result=str(0)+result
                    
                plus=1&0

            	
                    
              
            i+=1
        i=0
        while i<len(long1)-len(short):
            if long1[len(short)+i]=='0':
                result=str(plus)+result
                result=long1[0:len(long1)-len(short)-i-1]+result
                break
            if long1[len(short)+i]=='1':
                if plus==1:
                    result=str(0)+result
                    plus=1
                else:
                    result=str(1)+result
                    plus=0
            i+=1
        if plus==1:
            result=str(1)+result
        return result


if __name__=='__main__':
	a='1010'
	b='1011'

	c=Solution
	print(Solution.addBinary(a,b))