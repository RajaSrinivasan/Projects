#!/usr/bin/python3
import os
import time
import uuid
myid=str(uuid.uuid1())
#myid="srini"
LOCKFILE='nodelock'

def IsNodeLocked():
    files=os.listdir('.')
    print(files)
    if LOCKFILE in files:
        return True
    else:
        return False

def LockNode():
    f=open(LOCKFILE,'w')
    print(myid,file=f)
    f.close()

def IsLockMine():
    f=open(LOCKFILE,'r')
    lockid=f.read()
    f.close()
    if lockid.strip() == myid:
        return True
    else:
        return False

def Unlock():
    os.remove(LOCKFILE)

if IsNodeLocked():
    print("locked")
    time.sleep(10)
else:
    print("not locked. locking")
    LockNode()
    time.sleep(10)
    if IsLockMine():
        print("Lock is mine. I am ok")
        time.sleep(10)
        print("Unlocking")
        Unlock()
    else:
        print("Lock is not mine.")
