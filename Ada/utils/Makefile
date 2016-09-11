SPECS := $(wildcard *.ads)
BODIES := $(wildcard *.adb)
LISTINGS := $(SPECS:%.ads=%.ads.lis) $(BODIES:%.adb=%.adb.lis)
EXECS=dump digest lister linecount newutil striptabs
LOGS= $(addsuffix .log,$(EXECS))
EXECDIR=../build

all:
	gprbuild -p -P dump
	gprbuild -p -P digest
	gprbuild -p -P lister
	gprbuild -p -P linecount
	gprbuild -p -P newutil
	gprbuild -p -P striptabs

clean:
	gprclean -P dump
	gprclean -P digest
	gprclean -P lister
	gprclean -P linecount
	gprclean -P newutil
	gprclean -P striptabs
	rm -f $(LISTINGS) $(LOGS)

%.ads.lis : %.ads
	lister $(<) > $(@)
%.adb.lis : %.adb
	lister $(<) > $(@)

%.log :
	$(EXECDIR)/$(basename $(@)) > $(@)

list: all $(LISTINGS) $(LOGS)
