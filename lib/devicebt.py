#!/usr/bin env python 3.4 

from device import device 

 
class devicebt(device): 


 	def __init__(self,os,bt,btle): 


 		super().__init__(self,sim=False) 


 		self.os=os 


 		self.bt=bt 

 		self.btle=btle 



 


 	def turnonBT(self): 


 		pass 



 


 	def turnonLE(self): 

 		pass 



 


 	def turnoffBT(self): 

 		pass 



 


 	def inquiry(self): 

 		pass 



 


 	def lescan(self): 

 		pass 



 


 	def acceptpairingfalse(self): 

 		pass 



 


 	def connect(self): 

 		pass 



 


 	def disconnect(self,device,transport): 

 		pass 



 



 


 	def bond(self,device,transport): 

 		pass 


 	def discoverservice(self,device): 

 		pass 

 
 	def enableadvertise(self): 

 
 		pass 

 
 	def disableadvertise(self): 

 
 		pass 

 
 	def buildadvertise(self): 

 		pass 
