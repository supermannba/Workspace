#!/usr/bin env python 3.4

import os
import time

filename1='NotifyDUT.txt'
filename2='NotifyBM3.txt'
command1='adb push '
command3='adb pull '
command2='adb root'
path1='/data/'


with open(filename1,'w') as f:
	f.write('DUT enableLE')
	f.close()

os.system(command1+filename1+' '+path1)
time.sleep(2)
os.system(command3+path1+filename2)

with open(filename2,'r') as f:
	for line in f:
		if 'PASS' in line:
			print('test command pass')
	f.close()
