#!/usr/bin env python 3.4


import adbmodule,sys
import os,time,enums
global objectpath
global commandfile
import re,subprocess
import shutil
global advaddr
advaddr='1'


class Handler(object)

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
					return True,advaddr
				else:
					return False,advaddr
					break
			else:
				time.sleep(1)

		except Exception as e:
			return False
			print(e) 

def notifyremote(filename,host):
	with open(enums.Filename.tempresultfile.value,'r') as f:
		for line in f:
			if 'PASS' in line or 'FAIL' in line:
				command=line
	with open(filename,'w') as f:
		f.write(command)
		f.close()
	networkpath=getnetworkpath(host)
	print('stage1')
	try:
		filename1=os.getcwd()+'\\'+filename
		print(filename1)
		shutil.copyfile(os.path.join(os.getcwd()+'\\'+filename),os.path.join(networkpath+filename))
	except Exception as e:
		print(e)

def getnetworkpath(host):
	for i in enums.networkpath:
		if host==i.name:
			networkpath1=i.value
			return networkpath1
		
	print('could not find the path')

def checknotify(filename,host):
	path1=getnetworkpath(host)
	while True:
		if os.path.isfile(filename):
			break
		time.sleep(1)
	return True


def readnotify(filename,networkpath):
	filename1=networkpath+filename
	with open(filename1,'r') as f:
		for line in f:
			if 'PASS' in line:
				return True
			else:
				return False


def verifyremote(command,filename):
	host=enums.networkpath.selfhost.name
	path1=getnetworkpath(host)
	filename1=path1+filename
	notify=False
	print('waiting for result from other side for command:%s' % command)
	notify=checknotify(filename,host)
	if notify:
		for i in range(300):
			if os.path.isfile(filename1):
				file1=open(filename1,'r')
				for line in file1:
					if command in line:
						return True
						break
			i=i+1
			time.sleep(1)
		print('Process Failure')
		return False






