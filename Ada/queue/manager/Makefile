SPECS := $(wildcard *.ads)
BODIES := $(wildcard *.adb)
LISTINGS := $(SPECS:%.ads=%.ads.lis) $(BODIES:%.adb=%.adb.lis)
EXECS=qmanager
LOGS= $(addsuffix .log,$(EXECS))
EXECDIR=../../build

all :
	gprbuild -p -P qmanager.gpr

clean:
	gprclean -P qmanager.gpr
	rm -f $(LISTINGS) $(LOGS)

%.ads.lis : %.ads
	lister $(<) > $(@)
%.adb.lis : %.adb
	lister $(<) > $(@)

%.log :
	$(EXECDIR)/$(basename $(@)) > $(@)

list: all $(LISTINGS) $(LOGS)
