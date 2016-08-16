SPECS := $(wildcard *.ads)
BODIES := $(wildcard *.adb)
LISTINGS := $(SPECS:%.ads=%.ads.lis) $(BODIES:%.adb=%.adb.lis)
EXECS=crc16test factors_test numbers_test testlogging zlibtest
LOGS= $(addsuffix .log,$(EXECS))
EXECDIR=../build

all:
	gprbuild -p -P crc16test
	gprbuild -p -P factors_test
	gprbuild -p -P testlogging
	gprbuild -p -P zlibtest

clean:
	gprclean -P crc16test
	gprclean -P factors_test
	gprclean -P testlogging
	gprclean -P zlibtest
	rm -f $(LISTINGS) $(LOGS)

%.ads.lis : %.ads
	lister $(<) > $(@)

%.adb.lis : %.adb
	lister $(<) > $(@)

%.log :
	$(EXECDIR)/$(basename $(@)) > $(@)

list: all $(LISTINGS) $(LOGS)
