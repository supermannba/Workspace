 #!/usr/bin env python 3.4

from Base import Base

import os

import signal

import adbmodule

import subprocess

from subprocess import Popen

from multiprocessing import Process

import threading,time

class Class1(Base):
 	
 	dut='DUT'

 	def __init__(self,deviceid,bt,btle):
 		Base.__init__(self,a='Andriod',b='MTP')
 		self.deviceid=deviceid
 		self.bt=bt
 		self.btle=btle

 	def summary(self,a,b):
 		c=self.plus(a,b)
 		return c*a*b

threadLock=threading.Lock()
thread=[]

class myThread(threading.Thread):
	def __init__(self,threadID,name):
		threading.Thread.__init__(self)
		self.threadID=threadID
		self.name=name

	def run(self):
		print("Start "+self.name)
		threadLock.acquire()
		try:
			threadcommand(self.name,5,1)
		finally: 
			threadLock.release()

def threadcommand(threadName,delay,flag):
	time.sleep(delay)
	if flag==1:
		subprocess.call("start /wait cmd /k adb shell logcat -v time | tee logcat_v1.txt",shell=True)
	elif flag==2:
		subprocess.call("start /wait cmd /k adb shell cat /proc/kmsg -v time | tee kernel.txt",shell=True)
	else:
		print("%s is running" % threadName)

def thread2(args1,stop_event):
	while(not stop_event.is_set()):
		stop_evetn.wait(time)

if __name__=="__main__":


	example=Class1(deviceid='adbcd',bt=True,btle=False)

	example.victory=3
	
	print(example.victory)

	cmd="start /wait cmd /k adb shell logcat -v time | tee logcat_v2.txt"
	process1=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	# cmd1="start /wait cmd /k adb shell logcat -v time | tee logcat_v3.txt"
	# process2=subprocess.Popen(cmd1,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	
	#process1.start()
	#process2.start()
	done=False
	i=0
	while not done:
		#print(done)
		if i>5:
			#process1.kill()
			#process1.send_signal(signal.SIGINT)

			#Popen("TASKKILL /F /PID {pid} /T".format(pid=process1.pid))
			#Popen("TASKKILL /F /PID {pid} /T".format(pid=process2.pid))
			#p1.start()
			break
		time.sleep(1)
		i=i+1
		

	#p1.terminate()
	#Popen("TASKKILL /F /PID {pid} /T".format(pid=process1.pid))
	#thread1=myThread(1,"Thread-1")
	# t2_stop=threading.Event()
	# t2=threading.Thread(target=thread2,args=(2,t2_stop))

	# #thread1.start()

	# time.sleep(5)
	# t2_stop.set()
	# #thread1.join()



	

	