#!/usr/bin env python 3.4


import adbmodule,sys
import os,time
global objectpath
global commandfile
import re,subprocess



def sendcommand(command,filename):
	f=open(filename,'w')
	f.write(command)
	f.close()


def readresult(device,objectpath,filename,command):
	resultfile=objectpath+filename
	# while True:
	# 	t=subprocess.check_output(["adb","-s",device,"shell","find",resultfile],shell=True)
	# 	t1=str(t)
	# 	#print(t1)
	# 	if filename in t1:
	# 		break
	# 	else:
	# 		time.sleep(0.5)
	while True:
		try:
			t=subprocess.check_output(["adb","-s",device,"shell","cat",resultfile],shell=True)
			t1=str(t)
			if command in t1:
				s=subprocess.call(["adb","-s",device,"shell","rm",resultfile],shell=True)
				if 'PASS' in t1:
					print(command+' PASS')
				else:
					print(command+' FAIL')
				break
			else:
				time.sleep(4)

		except Exception as e:
			print(e)