 #!/usr/bin env python 3.4
'''
Created on Sep 4, 2015

@author: asiaynrf
'''
from devicebt import devicebt

import sendcommand
import enums,os
import adbmodule,time
import socket,sys,logging
import subprocess

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
    global outputfile
    global Test1
    global advaddr
    global advname
    global datalength
    
    commandfile='NotifyDUT.txt'
    resultfile='NotifyBM3.txt'
    tempresultfile='Tempresult.txt'
    outputfile='result.txt'
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
    enable='true'
    serviceuuid='serviceuuid'
    advname="cstadv"
    datalength=251

    def __init__(self,deviceid,bt,btle,sequence,commandfile,objectpath):
        devicebt.__init__(self,os='Android',bt=True,btle=True)
        self.deviceid=deviceid
        self.bt=bt
        self.btle=btle
        self.sequence=sequence
        self.commandfile=commandfile
        self.objectpath=objectpath
        self.logger=logging.getLogger(__name__)

    def createcommandfile2(self,filename):
        if not os.path.isfile(filename):
            open(filename,'w')
            self.logger.info("new command file created")

    def removecommandfile(self,filename):
        if os.path.exists(filename):
            os.remove(filename)
            self.logger.info("existed command file removed")


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
    def onecommmand(self,command,filename):
        try:
            with open(filename,'w') as f:
                f.write(command+'\n')
                f.close()
        except FileNotFoundError as e:
            self.logger.error("command file NotifyBM3.txt not found")
            print(e)

    def executing(self,command,filename):
        try:
            with open(filename,'a') as f:
                f.write(command+'\n')
                f.write(self.sleep(1000)+'\n')
                self.logger.info("current command {} is added to the command file".format(command))
                f.close()
        except FileNotFoundError as e:
            print(e)

    def executing1(self,command,addrflag=0):
        self.removecommandfile(self.commandfile)
        self.createcommandfile2(self.commandfile)
        self.onecommmand(command,self.commandfile)
        adbwrapper.adbpush(self.deviceid,self.commandfile,self.objectpath)
        result=self.verifycommands(self.objectpath,self.commandfile,objectfile)
        if result:
            self.logger.info("Command executing pass")
        else:
            self.logger.info("Command executing fail")
        if addrlfag==1:
            addr=self.getadvtiseraddres()
            if addr!=-1:
                self.remoteaddr=addr
                return True;
            else:
                return False
        else:
            for line in result[1]:
                if 'PASS' in line:
                    return True
                else:
                    return False
        # sendcommand.sendcommand(command,commandfile)
        # adbwrapper.adbpush(self.deviceid,commandfile,objectpath)
        # t=sendcommand.readresult(self.deviceid,self.objectpath,resultfile,command)
        # if t[0]:
        #     result=self.deviceid+' '+command+' : '+'PASS'
        #     print(result)
        # else:
        #     result=self.deviceid+' '+command+' : '+'FAIL'
        #     print(result)
        # # self.writetolog(command,filename,result,temp=0)
        # # self.writetolog(command,tempresultfile,result,temp=1)
        # if t[1] is not '1':
        #     self.advaddr=t[1]
        # time.sleep(1)

    '''test procedure'''
    def startstop(self,filename):
        command1="TestCase Start"
        command2="TestCase End"
        with open(filename,'r+') as f:
            content=f.read()
            f.seek(0,0)
            f.write(command1.rstrip('\r\n')+'\n'+content+command2)


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

    def scanforname1(self,serial,name):
        command1='scanfordevicename'
        command=' '.join([dut,str(serial),ble,client,command1,name])
        if self.executing1(command):
            return True
        else:
            return False 



    def lescan(self,serial,deviceaddr):
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

    def clientconnectionpriority(self,serial,priority,deviceaddr):
        command1='setconnectionpriority'
        command=' '.join([dut,str(serial),ble,client,command1,deviceaddr,str(priority)])
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

    def setnotificationinterval(self,serial,interval):
        command1='setnotificationinterval'
        if interval<0 or interval>600000:
            self.logger.error("invalid notification interval")
            return
        else:
            command=' '.join([dut,str(serial),ble,server,command1,str(interval)])
            self.executing(command,self.commandfile)

    '''timevalue in ms'''
    def setnotificationinterval(self,serial,timevalue):
        command1='setnotificationinterval'
        command=' '.join([dut,str(serial),server,command1,str(timevalue)])
        self.executing(command,self.commandfile)

    def setnotificationinterval1(self,serial,timevalue):
        command1='setnotificationinterval'
        command=' '.join([dut,str(serial),server,command1,str(timevalue)])
        self.executing1(command,self.commandfile)

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
        command=' '.join([dut,str(serial),ble,peripheral,'addadvdata',str(instance),command1,enable])
        self.executing(command,self.commandfile)


        
    '''wrapper class for complicated operation'''

    def initialize(self,commanfile):
        self.removecommandfile(commandfile)
        self.createcommandfile2(commandfile)
        self.turnonBT()
        self.turnonLE()

 

    def turnonBTLE(self):
        self.turnonBT()
        self.turnonLE()

    def advertising(self,serial,instance,advmode,advpower,connectable,timeout,name,remotehost,datalength=251,UUID=enums.UUID.UUID0.value):

        self.setname(serial,name)
        self.startbuildadvertiser(instance)
        self.advertisingwithname(serial,instance,enable)
        self.addadvdataUUID(UUID,instance)
        self.configurenewservicewithdatalength(serial,datalength)
        self.setadvsetting(instance,advmode,advpower,connectable,timeout)
        self.buildadvertiser(instance)
        self.startadvertising(instance)
        self.logger.info("advertising start")
        command="advertising instance {} is started".format(instance)
        return command 

    def scanandconnect(self,serial,deviceaddr,datalength):
        self.lescan(serial,deviceaddr)
        self.connect(serial,deviceaddr)
        self.configuremtu(serial,deviceaddr,datalength)
        self.discoverservices(self,deviceaddr)
        self.logger.info("connection to remote device")
        command="client connection is finished"
        return command

    def writedescriptor(self,serial,UUID16bit,Characteristic,Descriptor,operation1,writedata):
        self.discoverservices(serial,deviceaddr)
        self.writedescriptor(serial,deviceaddr,UUID16bit,Characteristic,Descriptor,operation1,writedata)
        self.logger.info("try to enable notification")


    def verifycommands(self,objectpath,commandfile,objectfile,outputfile):
        resultfile=objectpath+objectfile;
        with open(commandfile,'r') as file1:
            firstline=file1.readline()
            count=0
            for line in file1:
                if 'DUT' in line and 'common' not in line:
                    count+=1
            self.logger.info("overall number of command to execute it {}".format(count))
            result=[]
            self.logger.info("start checking result file")
            if "TestCase Start" not in firstline:
                self.logger.info("executing is in single command mode")
                while True:
                    try:
                        outputline=subprocess.check_output(["adb","-s",device,"shell","cat",resultfile],shell=True)
                        outputline1=str(outputline.decode('utf-8'))
                        if 'PASS' in outputline1 or 'FAIL' in outputline1:
                            s=subprocess.call(["adb","-s",device,"shell","rm",resultfile],shell=True)
                            result.append(outputline1)
                            return True,result
                        else:
                            return False,result
                    except Exception as e:
                        return False
                        self.logger.error("single command running failure "+e)
            else:
                self.logger.info("executing is in without usb command mode")
                self.removecommandfile(outputfile)
                self.createcommandfile2(outputfile)
                prev=0
                while count1<count:
                    try:
                        outputline=subprocess.check_output(["adb","-s",self.deviceid,"shell","cat",resultfile],shell=True)                     
                        outputline1=str(outputline)
                        self.logger.info("checking the result")
                        '''remove the notifybm3.txt log file'''
                       
                        outputresult=outputline1.split('\\r\\r\\n')
                        if(len(outputresult)>0):
                            count1=0
                            for line in outputresult:
                                if 'FAIL' in line:
                                    self.logger.info("command execution of {} failed".format(line))
                                    result.append(line)
                                    break;
                                # elif 'PASS' in line and outputresult.index(line)+1>len(result):
                                elif 'PASS' in line:
                                    if 'common' not in line:
                                        count1+=1    
                            self.logger.info("number of count is {}".format(count))
                    except Exception as e:
                        self.logger.error("without usb command result reading failure "+e)
                        return False,result
                    time.sleep(2)
                s=subprocess.call(["adb","-s",self.deviceid,"shell","rm",resultfile],shell=True)
                for line in outputresult:
                    if ('PASS' in line or 'FAIL' in line) and 'common' not in line:
                        result.append(line)
                
                with open(outputfile,'a') as outputfile1:
                    for line in result:
                        outputfile1.write(line+'\n')
                    outputfile1.close()
                return True,result

    def verifycommandpass(self,result,mode=1,command=None):
        countpass=0
        countfail=0
        if mode==1:
            if len(result)<=0:
                return False
            else:
                for line in result:
                    if 'PASS' in line:
                        countpass+=1
                    else:
                        countfail+=1
                if len(result)==countpass:
                    return True
                else:
                    return False
        elif mode==2:
            if len(result)<=0:
                return False
            else:
                for line in result:
                    if 'PASS' in line and command in line:
                        return True;
                return False;




    def getadvtiseraddress(self,result):
        for line in result:
            if utils.enums.stringpattern.string14 in line:
                index1=line.index(enums.stringpattern.string14.value)
                index2=index1+len(enums.stringpattern.string14.value)
                return line[index2:index2+17]
        return -1


    

def main():
    # devicelist=adbmodule.adbdevice()s
    # dut1=Androiddevicebt2(deviceid=devicelist[0],bt=True,btle=True,sequence=1,commandfile=commandfile,objectpath=objectpath)
    # dut1.removecommandfile(dut1.commandfile)
    # dut1.createcommandfile2(dut1.commandfile)
    # dut1.turnonBT()
    # dut1.turnonLE()
    # notify=dut1.advertising(serial=1,instance=1,advmode=enums.Advertisingmode.lowlatency.value,advpower=enums.Advertisingpower.highpower.value,connectable=enums.Connectable.connectable.value,timeout=0,datalength=251,name=advname,remotehost='WCONNECT-BT-39')
    # dut1.startstop(dut1.commandfile)
    # print(notify)
    pass

if __name__=="__main__": main()