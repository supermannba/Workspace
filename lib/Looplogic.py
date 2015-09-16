#!/usr/bin env python 3.4
'''
Created on Sep 8, 2015

@author: asiaynrf
'''

class CommandLogic(object):
    def __init__(self):
        pass
    
    def writecommand(self,filename,command):
        infile=open(filename,'a')
        infile.write(command)
        infile.close
    
    def teststart(self,filename):
        try:
            infile=open(filename,'r')
            data=infile.read()
            infile.close()
            with open(filename,'w') as modified:
                modified.write("TestCase Start\n"+data)
        except FileNotFoundError as e:
            print(e)
    
    def teststop(self,filename):
        try:
            with open(filename,'a') as infile:
                infile.write("TestCase End\n")
        except FileNotFoundError as e:
            print(e)
    
     
    
    
        
