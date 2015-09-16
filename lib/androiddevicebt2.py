 #!/usr/bin env python 3.4
'''
Created on Sep 4, 2015

@author: asiaynrf
'''
from devicebt import devicebt

import sendcommand
import enums
import adbmodule,time
import socket,sys

class Androiddevicebt(devicebt):
    '''
    classdocs
    '''
    global dut
    global BT
    global BLE
    global ble
    global client
    global server
    global peripheral
    global central
    global enable
    global serviceuuid
    global objectpath
    global commandfile
    global tempresultfile
    global resultfile
    global Test1
    global advaddr
    
    commandfile='NotifyDUT.txt'
    resultfile='NotifyBM3.txt'
    tempresultfile='Tempresult.txt'
    objectpath='/data/'
    Test1='Test1'
    dut='DUT'
    BT='BT'
    BLE='BLE'
    ble='ble'
    client='leclient'
    server='leserver'
    peripheral='peripheral'
    central='central'
    enable=1
    serviceuuid='serviceuuid'

    def __init__(self,deviceid,bt,btle,sequence,commandfile,objectpath):
        devicebt.__init__(self,os='Android',bt=True,btle=True)
        self.deviceid=deviceid
        self.bt=bt
        self.btle=btle
        self.sequence=sequence
        self.commandfile=commandfile
        self.objectpath=objectpath


    def creatlogfile(self,path):
        name=self.logname()
        name1=path+'\\'+name
        try:
            file1=open(name1,'w')
            file1.write('%s Started Execution\n' % Test1)
            file1.close()
            self.logfile=name1
            return name1
        except:
            print('could not generate log file')
            sys.exit(0)

    def createtemplog(self):
        name=tempresultfile
        try:
            file1=open(name,'w')
            file1.close()
        except:
            print('could not generate temp log')
            sys.exit(0)

    def logname(self):
        name=self.deviceid+'_DUT'+str(self.sequence)+'_execution'+'.txt'
        return name

    def logcatname(self):
        name=self.deviceid+'_DUT'+str(self.sequence)+'_logcat'+'.txt'
        return name

    def writetolog(self,command,filename,result,temp):
        if temp==0:
            option='a'
        elif temp==1:
            option='w'
        try:
            with open(filename,option) as f:
                f.write('Executing '+self.deviceid+' '+command+'\n')
                f.write(result+'\n')
                f.close()
        except:
            print('could not write to the log file')


    #executing
    def executing(self,command,filename):
        try:
            with open(filename,'a') as f:
                f.write(command+'\n')
                f.close()
        except FileNotFoundError as e:
            print(e)


    '''initialization'''
    def turnonBT(self):
        command1='enableBT'
        command=' '.join([dut,command1])
        self.executing(command,self.commandfile)
        

    def turnonLE(self):
        command1='enableLE'
        command=' '.join([dut,command1])
        self.executing(command,self.commandfile)

    '''pairing'''
    def autoacceptpairingrequest(self,enable):
        command1='autoacceptnextpairingrequest'
        command=' '.join([dut,BT,command1,enable])
        self.executing(command,self.commandfile)