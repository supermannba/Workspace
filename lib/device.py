#!/usr/bin env python 3.4

import os
import time

from subprocess import check_output,Popen

class device(object):
	def __init__(sefl,product,sim=False):
		device.product=product
		device.sim=sim

	def bootup(self):
		pass

	def shutdown(self):
		pass


	def wakeup(self):
		pass


	def sleep(self):
		pass

		