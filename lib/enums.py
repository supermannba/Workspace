#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from enum import Enum


'''file name'''
class Filename(Enum):
	commandfile='NotifyDUT.txt'
	resultfile='NotifyBM3.txt'


'''advertising introduction'''
class Advertiserpower(Enum):
	unltralowpower=0
	lowpower=1
	mediumpower=2
	highpower=3

class Advertisermode(Enum):
	lowpower=0
	balanced=1
	lowlatency=2

class Connectable(Enum):
	connectable='True'
	notconnectable='False'

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

class Characteristic(Enum):
	CID0='1100'

class readwriteoperation(Enum):
	operationwrite='00'

class writedata(Enum):
	data00='00'
	data01='01'
	data02='02'
	
class stringpattern(Enum):
	string11='beginning of system'
	string12='btm_ble_multi_adv_write_rpa-BD_ADDR:'
	string13='inst_id:'

class writedescriptor(Enum):
	read=1
	write=2
	notification=3
	indication=4




