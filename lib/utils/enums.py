#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from enum import Enum


'''file name'''


class Filename(Enum):
	commandfile='NotifyDUT.txt'
	resultfile='NotifyBM3.txt'
	notifyfile='Resultnotify.txt'
	tempresultfile='Tempresult.txt'
	objectpath='/data/'
	logpath='\\Log\\Test\\'

class apkinstall(Enum):
	apkpath='C:\\CST_QSPR\\qualcomm_bin\\Android\\MRelease\\'
	apkname='ConnectivitySystemTest.apk'
	apkintent='com.android.CST/.ConnectivitySystemTest.ConnectivitySystemTest'

'''networkpath'''
class networkpath(Enum):
	selfhost='C:\\Dropbox\\Test\\'
	astbt11='\\\\ast-bt11\\Dropbox\\Wipower\\test\\'
	BTTESTWS2='\\\\BT-TEST-WS2\\Dropbox\\Test\\'
	WCONNECTBT39='\\\\WCONNECT-BT-39\\Dropbox\\Test\\'

class Hostname(Enum):
	Localhost='localhost'
	WCONNECTBT39='WCONNECT-BT-39'
	BTTESTWS2='BT-TEST-WS2'
	supermannba='supermannba'

class Tcpport(Enum):

	port1=80
	port2=8888
	port3=50000
	port4=50001


'''advertising introduction'''
class Advertisingpower(Enum):
	unltralowpower=0
	lowpower=1
	mediumpower=2
	highpower=3

class Advertisingmode(Enum):
	lowpower=0
	balanced=1
	lowlatency=2

class Connectable(Enum):
	connectable='true'
	notconnectable='false'

class UUID(Enum):
	UUID0='0000110D-0000-1000-8000-00805F9B34FB'
	UUID1='00001801-0000-1000-8000-00805F9B34FB'
	UUID2='00001802-0000-1000-8000-00805F9B34FB'
	UUID3='00001803-0000-1000-8000-00805F9B34FB'
	UUID4='00001804-0000-1000-8000-00805F9B34FB'
	UUID5='00001805-0000-1000-8000-00805F9B34FB'
	UUID6='00001806-0000-1000-8000-00805F9B34FB'
	UUID7='00001807-0000-1000-8000-00805F9B34FB'
	UUID8='00001808-0000-1000-8000-00805F9B34FB'
	UUID9='00001809-0000-1000-8000-00805F9B34FB'

class UUID16bit(Enum):
	UUID0='1200'
	UUID1='1201'
	UUID2='1202'
	UUID5='1205'

class Characteristic(Enum):
	CID0='1100'
	CID1='1115'


class Descriptor(Enum):
	DES0='2902'


class readwriteoperation(Enum):
	operationwrite='00'

class writedata(Enum):
	data00='00'
	notification='01'
	indication='02'
	
class stringpattern(Enum):
	string11='beginning of system'
	string12='btm_ble_multi_adv_write_rpa-BD_ADDR:'
	string13='inst_id:'
	string14='The address for device is:'

class writedescriptor(Enum):
	read=1
	write=2
	notification=3
	indication=4


class noticeevent(Enum):

	advertising='advertising'
	advertisingstart='DUT BLE peripheral startadv'
	turnleon='DUT enableLE'
	notificaitoninterval='setnotification'


