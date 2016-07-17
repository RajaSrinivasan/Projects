#!/usr/bin/env python3
import os

SPRINT_BEGIN_DATE=["1-JAN-2016" ,
                   "15-JAN-2016" ,
                   "1-FEB-2016" ,
                   "15-FEB-2016" ,
                   "1-MAR-2016" ,
                   "15-MAR-2016"]
def ShowBranch():
    CURRENT_BRANCH_CMD = 'git rev-parse --abbrev-ref HEAD'
    os.system(CURRENT_BRANCH_CMD)

def ShowDateRange():
    GITLOG_CMD='git log --since="%s" --until="%s" --all --format="%s"'
    for beg in range(0,len(SPRINT_BEGIN_DATE)-1):
        print(SPRINT_BEGIN_DATE[beg] , " -> " , SPRINT_BEGIN_DATE[beg+1])
        cmd=GITLOG_CMD % (SPRINT_BEGIN_DATE[beg],SPRINT_BEGIN_DATE[beg+1],'%H')
        os.system(cmd)
ShowBranch()
ShowDateRange()