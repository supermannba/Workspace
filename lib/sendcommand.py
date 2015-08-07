#!/usr/bin env python 3.4


import adbmodule,sys

global objectpath
global commandfile


def sendcommand(command,filename):
	f=open(filename,'w')
	f.write(command)
	f.close()


def readresult(device,objectpath,filename):
	adbmodule.adbpull(device,filename,objectpath)
	try:
		with open(filename,'r') as f:
			for line in f:
				if "PASS" in line:
					print(line)
				else:
					print(line)

	except Exception as e:
		print(e)