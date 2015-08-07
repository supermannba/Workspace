 #!/usr/bin env python 3.4

import subprocess
import re

from subprocess import Popen,PIPE,STDOUT,check_output, CalledProcessError

#to perform adb root on the windows machine
def adbroot(device):
	try:
		t=subprocess.call(["adb","-s",device,"root"],shell=True)
	except CalledProcessError as e:
		t=e.returncode, e.message

def adbwaitfordevice():
	try:
		t=subprocess.call(["adb","wait-for-devices"],shell=True)
	except CalledProcessError as e:
		t=e.returncode, e.message

#to get the device id on the windows 		
def adbdevice(): 
	try: 
		out=check_output(["adb","devices"])
		t=0
		adb1=out.split(b'device\r')
		found=[]
		for a in adb1:
			try:
				found1=re.search('\n(.+?)\t',a.decode("utf-8")).group(1)
				found.append(found1)
			except AttributeError as e:
				found1=''
		if len(found)<1:
			print("not device connected")
			return None
		else:
			return found 
	except CalledProcessError as e:
		t=e.returncode, e.message

def adbremount(device):
	try:
		t=subprocess.call(["adb","-s",device,"remount"],shell=True)
	except CalledProcessError as e:
		t=e.returncode, e.message


def adbpush(device,filename,objectpath):
	try:
		t=subprocess.call(["adb","-s",device,"push",filename,objectpath],shell=True)
	except CalledProcessError as e:
		t=e.rturncode,e.meesage


def adbpull(device,filename,originpath):
	try:
		t=subprocess.call(["adb","-s",device,"pull",filename,originpath],shell=True)
	except CalledProcessError as e:
		t=e.rturncode,e.meesage