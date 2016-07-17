SPECS := $(wildcard *.ads)
BODIES := $(wildcard *.adb)
LISTINGS := $(SPECS:%.ads=%.ads.lis) $(BODIES:%.adb=%.adb.lis)
EXECS=ihexutil
LOGS= $(addsuffix .log,$(EXECS))
EXECDIR=../build

all:
	gprbuild -p -P ihexutil

clean:
	gprclean -P ihexutil
	rm -f $(LISTINGS) $(LOGS)

%.ads.lis : %.ads
	lister $(<) > $(@)
%.adb.lis : %.adb
	lister $(<) > $(@)

%.log :
	$(EXECDIR)/$(basename $(@)) > $(@)

list: all $(LISTINGS) $(LOGS)
