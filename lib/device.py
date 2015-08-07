 #!/usr/bin env python 3.4

import os
import time

from subprocess import check_output,Popen

class device(object):
 	def __init__(self,product,sim=False):
 		#device.os=os
 		device.product=product
 		device.sim=sim

 	def bootup(self):
 		#device boot up 
 		pass

 	def shutdown(self):
 		#device shut down
 		pass

 	def wakeup(self):
 		#device wake up from sleep
 		pass

 	def sleep(self):
 		#device going to sleep
 		pass




