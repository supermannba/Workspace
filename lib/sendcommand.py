#!/usr/bin env python 3.4


import adbmodule,sys
import os,time,enums
global objectpath
global commandfile
import re,subprocess



def sendcommand(command,filename):
	f=open(filename,'w')
	f.write(command)
	f.close()


def getbtaddr(line):
	line1=line
	index1=line1.index(enums.stringpattern.string14)
	index2=index1+len(enums.stringpattern.string14)
	return line1[index2:index2+17]


def readresult(device,objectpath,filename,command):
	resultfile=objectpath+filename
	while True:
		try:
			t=subprocess.check_output(["adb","-s",device,"shell","cat",resultfile],shell=True)
			t1=str(t)
			print(t1)
			if command in t1:
				s=subprocess.call(["adb","-s",device,"shell","rm",resultfile],shell=True)
				if 'PASS' in t1:
					if enums.stringpattern.string14 in t1:
						print("address found")
					return True
				else:
					return False
				break
			else:
				time.sleep(4)

		except Exception as e:
			return False
			print(e)