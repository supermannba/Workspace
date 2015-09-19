#!/usr/bin env python 3.4
#-*- coding: utf-8 -*-
import subprocess,re
from subprocess import Popen,PIPE
from threading import Thread
from queue import Queue,Empty
import time

command='adb -s 10b768bd shell logcat'
file1='test2.txt'

with open(file1,'a') as f:
	f.close()

def readoutput(process,out,queue):
	while process.poll() is None:
		output=process.stdout.readline()
		q.put(output)
		output1=q.get()
		with open(file1,'a') as f:
			f.write(output1.decode("utf-8") +'\n')

p=subprocess.Popen(command,stdout=PIPE,shell=True)
q=Queue()
t=Thread(target=readoutput,args=(p,p.stdout,q))
t.start()



try:
	line=q.get_nowait()
	print(line)
	
except Empty:
	print('no output yet')

else:
	print('done')

time.sleep(10)
p.kill()






