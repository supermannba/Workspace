#!/usr/bin env python 3.4

import serial,time
from Aeroflexattenuator import Aeroflexattenuator


if __name__=='__main__':

	attenuator1=Aeroflexattenuator('Aeroflex',95,comport=19,baudrate=115200,timeout=1)

	#print(attenuator1)

	#print(attenuator1.readattenuation())
	print(attenuator1.setattenuation(10.0))