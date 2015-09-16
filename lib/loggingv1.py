 #!/usr/bin env python 3.4

import os,signal,adbmodule,subprocess,time,shutil,threading
from subprocess import Popen,PIPE
from multiprocessing import Process
import re,sys,logging
from queue import Queue,Empty
from threading import Thread


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

def cleanlogcat(deviceid):
	string=["adb","-s",deviceid,"shell","logcat","-c"]
	command=' '.join(string)	
	print('cleanlogcat')
	try: 
		process=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	except Exception as e:
		print(e)


def startlogcat1(deviceid,filename):
	string=["adb","-s",deviceid,"shell logcat -v time"]
	command=' '.join(string)
	filename1=os.getcwd()+enums.Filename.logpath.value+filename
	with open(filename1,'w') as f:
		f.close()
	print('startlogcat')
	try: 
		process=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
		q=Queue()
		t=Thread(target=readoutput,args=(process,process.stdout,q))
		t.start()
		return process
	except Exception as e:
		print(e)
		return None

def stoplogcat(process):
	try:
		process.kill()
	except Exception as e:
		print(e)


def readoutput(process,queue,filename):
	while process.poll() is None:
		output=process.stdout.readline()
		queue.put(output)
		output1=queue.get()
		with open(filename,'a') as f:
			f.write(output1.decode("utf-8") +'\n')
			f.close()


def startlogcat(deviceid,filename):
	string=["adb","-s",deviceid,"shell logcat -v time | tee",filename]
	command=' '.join(string)
	print('startlogcat')
	try: 
		process=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
		return process
	except Exception as e:
		print(e)
		return None

def startkmsg(deviceid,filename):
	string=["adb","-s",deviceid,"shell cat /proc/kmsg -v time | tee",filename]
	command=' '.join(string)
	try: 
		process=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
		return process
	except Exception as e:
		print(e)
		return None

def stoplog(process):
	try:
		Popen("TASKKILL /F /PID {pid} /T".format(pid=process.pid))
	except Exception as e:
		print(e)

def savelogcat(path,filename,result):
	try:
		path1=os.getcwd()
		pathfile1=path1+'\\'+fielname
		pathfile2=path1+path+filename
		shutil.copyfile(pathfile1,pathfile2)
		if result:
			print("test finished,logcat collection done")
		else:
			return pathfile2
	except Exception as e:
		print(e)

def reverseaddr(string):
	addr1=string.split('-')
	addr1.reverse()
	addr2=':'.join(addr1)
	return addr2

def matching1(string1,string2,string):
	found=re.search('%s(.+?)%s' % (string1,string2),string).group(1)
	if found is not '':
		return found

def matching2(string1,string):
	found=re.search('%s(.+?)' % string1,string).group(1)
	if found is not '':
		return found

def getbtaddr(filename,instance,path):
	string1="btm_ble_multi_adv_write_rpa-BD_ADDR:"
	string2=",inst_id:"
	match=0
	with open(filename,'r') as f:
		for line in f:
			if string1 in line:
				try:
					match+=1
					found1=matching1(string1,string2,line)
					instance1=matching2(string1,line)
					addr=reverseaddr(found1)
					if instance==int(instance1):
						return addr
					else:
						if match==1:
							return addr
				except Exception as e:
					sys.exit()

def logging1(level):
	if level==0:
		level1=logging.INFO
	elif level==1:
		level1=logging.DEBUG
	logging.basicConfig(level=level1)
	logger=logging.getLogger(__name__)
	return logger




# if __name__=="__main__":
# 	print("start")
# 	devicelist=adbmodule.adbdevice()
# 	filename='logcat_v1.txt'
# 	process=startlogcat(devicelist[0],filename)
# 	print("stop")
# 	time.sleep(2)
# 	stoplogcat(process)

	#cmd="adb shell logcat -v time | tee logcat_v3.txt"
	#cmd1="adb shell logcat -v time | tee logcat_v4.txt"
	#cmd="start /wait cmd /k pushd C:\\Users\\Administrator\\Desktop\\lib;adb devices"
	#process1=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	
	#cmd="start /wait cmd /k adb shell logcat -v time | tee logcat_v3.txt"
	#process2=subprocess.Popen(cmd1,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	
	#process1.start()
	#process2.start()
	# done=False
	# i=0
	# while not done:
	# 	#print(done)
	# 	if i>5:
	# 		#process1.kill()
	# 		#process1.send_signal(signal.SIGINT)

	# 		Popen("TASKKILL /F /PID {pid} /T".format(pid=process1.pid))
	# 		Popen("TASKKILL /F /PID {pid} /T".format(pid=process2.pid))
	# 		#p1.start()
	# 		break
	# 	time.sleep(1)
	# 	i=i+1
		

	#p1.terminate()
	#Popen("TASKKILL /F /PID {pid} /T".format(pid=process1.pid))
	#thread1=myThread(1,"Thread-1")
	# t2_stop=threading.Event()
	# t2=threading.Thread(target=thread2,args=(2,t2_stop))

	# #thread1.start()

	# time.sleep(5)
	# t2_stop.set()
	# #thread1.join()



	

	