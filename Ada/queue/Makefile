SPECS := $(wildcard *.ads)
BODIES := $(wildcard *.adb)
LISTINGS := $(SPECS:%.ads=%.ads.lis) $(BODIES:%.adb=%.adb.lis)
SUBS=client manager
LOGS= $(addsuffix .log,$(EXECS))
EXECDIR=../build

all:
	$(MAKE) -C manager all
	$(MAKE) -C client all

clean:
	$(MAKE) -C manager clean
	$(MAKE) -C client clean

%.ads.lis : %.ads
	lister $(<) > $(@)
%.adb.lis : %.adb
	lister $(<) > $(@)

%.log :
	$(EXECDIR)/$(basename $(@)) > $(@)

list: all $(LISTINGS) $(LOGS)
