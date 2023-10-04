#include Makefile.config

SED := sed
CAT := cat
AWK := awk
COQC := coqc
OCAMLOPT := ocamlopt
COQMAKEFILE := coq_makefile
CP := cp
MV := mv
HEADACHE := headache

CLIGHTGEN=clightgen
CLIGHTGEN32=$(CLIGHTGEN32DIR)/clightgen

THIS_FILE := $(lastword $(MAKEFILE_LIST))

COQEXTRAFLAGS := COQEXTRAFLAGS = '-w all,-extraction,-disj-pattern-notation'


DIRS := theory rbpf32 jit

all:
	@echo $@
	@$(MAKE) theory
	@$(MAKE) document
   
Theory= Sets.v Contracts.v Simple_Logic.v Logic_Contract.v

COQTheory= $(addprefix theory/, $(Theory))

FILES= $(COQTheory)

theory:
	@echo $@
	$(COQMAKEFILE) -f _CoqProject $(COQTheory) $(COQEXTRAFLAGS)  -o CoqMakefile
	make -f CoqMakefile

DOCFLAG := -external https://compcert.org/doc/html compcert -base contract -short-names 
document:
	@echo $@
	mkdir -p html
	mkdir -p html/glob
	cp theory/*.glob html/glob
	coq2html $(DOCFLAG) -d html html/glob/*.glob theory/*.v

addheadache:
	@echo $@
	$(HEADACHE) -c head_config -h head \
	theory/*.v

clean :
	@echo $@
	make -f CoqMakefile clean
	find . -name "*\.vo" -exec rm {} \;
	find . -name "*\.vok" -exec rm {} \;
	find . -name "*\.vos" -exec rm {} \;
	find . -name "*\.glob" -exec rm {} \;
	find . -name "*\.aux" -exec rm {} \;
	find . -name "*\.cmi" -exec rm {} \;
	find . -name "*\.cmx" -exec rm {} \;
	find . -name "*\.crashcoqide" -exec rm {} \;

.SECONDARY:

.PHONY: all theory document addheadache clean
