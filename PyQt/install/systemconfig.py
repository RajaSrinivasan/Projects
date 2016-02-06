import re
class SystemConfig:
    saunames={"KBD" : "SAU_KBD" ,
              "PBM1" : "SAU_POWERMOD_1" ,
              "PBM2" : "SAU_POWERMOD_2" ,
              "AHP" : "SAU_PURGE" ,
              "EPM" : "SAU_SENS_EEP_1" ,
              "PMD" : "SAU_MOTOR_1"}

    keywords1=re.compile("System|EPC")
    keywords2=re.compile("SAU_POWERMOD|SAU_PURGE|SAU_MOTOR_1|SAU_KBD|SAU_SENS_EEP_1")
    sysverexp=re.compile("(System|EPC) rev (.*)")
    devverexp=re.compile("(SAU_POWERMOD_1|SAU_POWERMOD_2|SAU_PURGE|SAU_MOTOR_1|SAU_KBD|SAU_SENS_EEP_1) Version: ([A-Z]) ([0-9]+) ([^ ]*) (.*)$")
    def __init__(self):
        self.items = {}

    @staticmethod
    def getSauName(dev):
        if dev in SystemConfig.saunames:
            return SystemConfig.saunames[dev]
        return ""

    @staticmethod
    def getDevName(sau):
        for dev in SystemConfig.saunames:
            if SystemConfig.saunames[dev] == sau:
                return dev
        return ""

    @staticmethod
    def LoadConfigFile(filename):
        cfg = SystemConfig()
        for line in open(filename,'r'):
            if SystemConfig.keywords1.match(line):
                name, value = SystemConfig.extractSystemVersion(line)
                cfg.addConfigItem(name,value)
            elif SystemConfig.keywords2.match(line):
                name,value = SystemConfig.extractDeviceVersion(line)
                cfg.addConfigItem(name,value)
        return cfg

    @staticmethod
    def extractSystemVersion(line):
        sysvermatch=SystemConfig.sysverexp.match(line.rstrip("\n"))
        return sysvermatch.group(1),sysvermatch.group(2)


    @staticmethod
    def extractDeviceVersion(line):
        devvermatch=SystemConfig.devverexp.match(line.rstrip("\n"))
        return devvermatch.group(1) , [devvermatch.group(2) , devvermatch.group(3) , devvermatch.group(4) , devvermatch.group(5)]

    def addConfigItem(self,name,value):
        if name not in self.items:
            self.items[name] = value

    def getConfigItems(self,itemname):
        print("Looking for " , itemname)
        return self.items[itemname]
