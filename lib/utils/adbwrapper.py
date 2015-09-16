 #!/usr/bin env python 3.4

import subprocess
import os,re,sys
import enums
# import androiddevicebt
import logging
from subprocess import Popen,PIPE,STDOUT,check_output, CalledProcessError

#to perform adb root on the windows machine
#adb wrapper to perform the adb function
class adbwrapper:
	def __init__(self,logger=None):
		if logger is None:
			self.logger=logging.getLogger(__name__)

	def adbroot(self,device):
		try:
			t=subprocess.call(["adb","-s",device,"root"],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.returncode, e.message

	def adbwaitfordevice(self):
		try:
			t=subprocess.call(["adb","wait-for-devices"],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.returncode, e.message

	#to get the device id on the windows 		
	def adbdevice(self): 
		try: 
			out=check_output(["adb","devices"])
			t=0
			adb1=out.split(b'device\r')
			found=[]
			for a in adb1:
				try:
					found1=re.search('\n(.+?)\t',a.decode("utf-8")).group(1)
					self.logger.info("found new device with id {}".format(found1))
					found.append(found1)
				except AttributeError as e:
					found1=''
			if len(found)<1:
				self.logger.info("no device connected")
				return None
			else:
				return found 
		except CalledProcessError as e:
			t=e.returncode, e.message

	def adbremount(self,device):
		try:
			t=subprocess.call(["adb","-s",device,"remount"],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.returncode, e.message


	def adbpush(self,device,filename,objectpath):
		try:
			t=subprocess.call(["adb","-s",device,"push",filename,objectpath],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.rturncode,e.meesage


	def adbpull(self,device,filename,originpath):
		path=originpath+filename
		try:
			t=subprocess.call(["adb","-s",device,"pull",path],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.rturncode,e.meesage

	def installapk(self,device,apkname,apkpath):
		path=apkpath+apkname
		try:
			t=subprocess.call(["adb","-s",device,"install",path],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.rturncode,e.meesage

	def adbremove(self,device,apkname,apkpath):
		path=apkpath+apkname
		try:
			t=subprocess.call(["adb","-s",device,"shell","rm",path],shell=True)
		except CalledProcessError as e:
			self.logger.error("call process error")
			t=e.rturncode,e.meesage


	def initialization(self):
		self.adbwaitfordevice()
		devicelist=self.adbdevice()
		for device in devicelist:
			self.adbroot(device)
			self.adbremount(device)
			self.adbremove(device,enums.Filename.resultfile.value,enums.Filename.objectpath.value)
			self.installapk(device,enums.apkinstall.apkname.value,enums.apkinstall.apkpath.value)
			subprocess.call(["adb","-s",device,"shell","am","start","-n",enums.apkinstall.apkintent.value])
		return devicelist


	def createlogpath(self,test):
		path1=os.path.abspath(os.getcwd())
		path2='\\Log\\'
		path3=test
		path=path1+path2+path3
		print(path)
		if not os.path.exists(path):
			os.makedirs(path)
		return path

# def initializedut():
# 	devicelist=adbdevice()
# 	dut=[]
# 	for device in devicelist:
# 		dut.append(Androiddevicebt(deviceid=device,bt=True,btle=True,sequence=(devicelist.index(device)+1),commandfile=androiddevicebt.commandfile,objectpath=androiddevicebt.objectpath))
# 	return dut

def main():
	adbwrapper1=adbwrapper()
	devicelist=adbwrapper1.adbdevice()
	for device in devicelist:
		print(device)
		adbwrapper1.adbroot(device)
		adbwrapper1.adbremount(device)

if __name__=="__main__":main()


