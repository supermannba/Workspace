#!/usr/bin env python 3.4


import adbmodule,sys
import os,time,enums
global objectpath
global commandfile
import re,subprocess

global advaddr
advaddr='1'

def sendcommand(command,filename):
	f=open(filename,'w')
	f.write(command)
	f.close()


def getbtaddr(line):
	index1=line.index(enums.stringpattern.string14.value)
	index2=index1+len(enums.stringpattern.string14.value)
	return line[index2:index2+17]


def readresult(device,objectpath,filename,command):
	resultfile=objectpath+filename
	advaddr='1'
	while True:
		try:
			t=subprocess.check_output(["adb","-s",device,"shell","cat",resultfile],shell=True)
			t1=str(t)
	
			if command in t1:
				
				s=subprocess.call(["adb","-s",device,"shell","rm",resultfile],shell=True)
				if 'PASS' in t1:	
					if enums.stringpattern.string14.value in t1:
						advaddr=getbtaddr(t1)
						print("address found")
					else:
						print('PASS')
						return True,advaddr
				else:
					return False,advaddr
					break
			else:
				time.sleep(1)

		except Exception as e:
			return False
			print(e) 