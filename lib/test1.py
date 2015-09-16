#!/usr/bin env python 3.4

import subprocess,re
from threading import Thread

command='adb -s 10b768bd logcat'

with open('test1.txt','a') as f:
	f.close()

proc=subprocess.Popen(command,shell=True,stdout=subprocess.PIPE)
 
	while proc.poll() is None:
		output=proc.stdout.readline()
		with open('test1.txt','a') as f:
			f.write(output.decode("utf-8") +'\n')

output=proc.communicate()[0]
with open('test1.txt','a') as f:
	f.write(output.decode("utf-8") +'\n')
