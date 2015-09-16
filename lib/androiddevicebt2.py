 #!/usr/bin env python 3.4
'''
Created on Sep 4, 2015

@author: asiaynrf
'''
from devicebt import devicebt

import sendcommand
import enums,os
import adbmodule,time
import socket,sys

class Androiddevicebt2(devicebt):
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
    global advname
    
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
    advname="cstadv"

    def __init__(self,deviceid,bt,btle,sequence,commandfile,objectpath):
        devicebt.__init__(self,os='Android',bt=True,btle=True)
        self.deviceid=deviceid
        self.bt=bt
        self.btle=btle
        self.sequence=sequence
        self.commandfile=commandfile
        self.objectpath=objectpath

    def createcommandfile2(self,filename):
        if not os.isfile(filename):
            open(filename,'w')

    def creatcommandfile(self,path):
        name=self.logname()
        name1=path+'\\'+name
        try:
            file1=open(name1,'w')
            file1.write('%s Started Execution\n' % Test1)
            file1.close()
            self.commandfile=name1
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
                f.write(self.sleep(1000)+'\n')
                f.close()
        except FileNotFoundError as e:
            print(e)

    '''test procedure'''
    def startstop(self,filename):
        command1="TestCase Start"
        command2="TestCase End"
        with open(filename,'r+') as f:
            content=f.read()
            f.seek(0,0)
            f.write(command1.rstrip('\r\n')+'\n'+content+'\n'+command2)


    def teststart(self):
        command="TestCase Start"
        self.executing(command,self.commandfile)

    def teststop(self):
        command="TestCase End"
        self.executing(command,self.commandfile)

    def loopsetup(self,name,loopcount):
        command="Begin Loop "+name+" "+loopcount;
        self.executing(command,self,commandfile)

    def loopfinish(self,name,loopcount):
        command="End Loop "+name+" "+loopcount;
        self.executing(command,self,commandfile)

    def sleep(self,time):
        command1='common sleep'
        command=' '.join([dut,command1,str(time)])
        return command

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

    '''setname'''
    def setname(self,serial,name):
        command1='setname'
        command=' '.join([dut,str(serial),BT,command1,name])
        self.executing(command,self.commandfile)

    '''leclient command'''
    def scanforname(self,serial,name):
        command1='scanfordevicename'
        command=' '.join([dut,str(serial),ble,client,command1,name])
        self.executing(command,self.commandfile)
        
            

    def lescan(self,serial,ble,deviceaddr):
        command1='startscan'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
        self.executing(command,self.commandfile)


    def connect(self,serial,deviceaddr):
        command1='connect'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
        self.executing(command,self.commandfile)

    def discoverservices(self,serial,deviceaddr):
        command1='discoverservices'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr])
        self.executing(command,self.commandfile)

    def configuremtu(self,serial,deviceaddr,datalength):
        command1='configuremtu'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr,str(datalength)])
        self.executing(command,self.commandfile)

    def writedescriptor(self,serial,deviceaddr,UUID16bit,Characteristic,Descriptor,operation1,writedata):
        command1='writedescriptor'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr,str(UUID16bit),str(Characteristic),str(Descriptor),str(operation1),str(writedata)])
        self.executing(command,self.commandfile)

    '''leserver command'''

    def configurenewservicewithdatalength(self,serial,datalength):
        command1='configurenewservicewithdatalength'
        command=' '.join([dut,str(serial),ble,server,command1,str(datalength)])
        self.executing(command,self.commandfile)

    '''timevalue in ms'''
    def setnotificationinterval(self,serial,timevalue):
        command1='setnotificationinterval'
        command=' '.join([dut,str(serial),server,command1,str(timevalue)])
        self.executing(command,self.commandfile)

    '''advertising'''
    def startbuildadvertiser(self,instance):
        command1='startbuildingnewadv'
        command=' '.join([dut,BLE,peripheral,command1,str(instance)])
        self.executing(command,self.commandfile)


    def addadvdataUUID(self,UUID,instance):
        command1="addadvdata"
        command=' '.join([dut,BLE,peripheral,command1,str(instance),serviceuuid,UUID])
        self.executing(command,self.commandfile)


    def setadvsetting(self,instance,advmode,advpower,connectable,timeout):
        command1='setadvsettings'
        command=' '.join([dut,BLE,peripheral,command1,str(instance),str(advmode),str(advpower),str(timeout),connectable])
        self.executing(command,self.commandfile)


    def buildadvertiser(self,instance):
        command1='buildadv'
        command=' '.join([dut,BLE,peripheral,command1,str(instance)])
        self.executing(command,self.commandfile)


    def startadvertising(self,instance):
        command1='startadv'
        command=' '.join([dut,BLE,peripheral,command1,str(instance)])
        self.executing(command,self.commandfile)


    def stopadvertising(self,instance):
        command1='stopadv'
        command=' '.join([dut,BLE,peripheral,command1,instance])
        self.executing(command,self.commandfile)

    def advertisingwithname(self,serial,instance,enable):
        command1='includedevicename'
        command=' '.join([dut,str(serial),ble,peripheral,'addadvdata',str(instance),command1,str(enable)])
        self.executing(command,self.commandfile)
        

def main():
    devicelist=adbmodule.adbdevice()
    dut1=Androiddevicebt2(deviceid=devicelist[0],bt=True,btle=True,sequence=1,commandfile=commandfile,objectpath=objectpath)
    if not os.path.isfile(commandfile):
        open(commandfle,'a')
    else:
        dut1.teststart()
        dut1.turnonBT()
        dut1.sleep(1000)
        dut1.turnonLE()
        dut1.teststop()

if __name__=="__main__": main()