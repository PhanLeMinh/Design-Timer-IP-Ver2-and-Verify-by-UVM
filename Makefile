## -------------------------------------------------------------
# This file created by Huy Nguyen
# Updated date: 01/09/2024
# Example run string: make TESTNAME={name_of_testcase} {optional}
#		     make run TESTNAME=ahb_base_test 
## -------------------------------------------------------------
TESTNAME  ?= apb_base_test
TB_NAME   ?= test_bench
VERBOSITY ?= UVM_MEDIUM
SEED      ?= 1
RUNARG    ?=
COV       ?=ON
##--------------------------------------------------------------
ifeq ($(COV),ON)
  CMP_COV_OPT   = -coveropt 3 +cover=bcestf
  SIM1_COV_OPT  = -coverage -coveranalysis
  SIM2_COV_OPT  = coverage save -codeAll -cvg -onexit $(TESTNAME).ucdb;
endif

VSIM = vsim -c -sv_seed $(SEED) \
       -l $(TESTNAME)_$(SEED).log \
       -voptargs=+acc -debugDB -assertdebug \
       $(SIM1_COV_OPT) $(TB_NAME) \
       -do "log -r /*; $(SIM2_COV_OPT) run -all; quit"
run:
	mkdir -p log
	$(VSIM) +UVM_TESTNAME=$(TESTNAME) \
	        +UVM_VERBOSITY=$(VERBOSITY) \
	        $(RUNARG)
	mv $(TESTNAME)_$(SEED).log ./log/
	cp -f vsim.wlf log/$(TESTNAME)_$(SEED).wlf
	ln -sf ./log/$(TESTNAME)_$(SEED).log run.log

build:
	mkdir -p log
	vlib work
	vmap work work
	vlog ${CMP_COV_OPT} -timescale "1ns/1ps" -f compile.f | tee compile.log
cov_gui:
	vsim -i -viewcov ${TESTNAME}.ucdb &
cov_merge:
	rm -f      IP_MERGE.ucdb
	vcover merge IP_MERGE.ucdb *.ucdb

wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*;" &
clean: 
	rm -rf work
	rm -rf log
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.log#
	rm -rf *.trace
	rm -rf *.wlf
	rm -rf transcript
	rm -rf *.ucdb
	rm -rf vsim.dbg
	rm -rf tmp_report
	rm -rf *.txt

help: 
	@echo ""
	@echo "****************************************"
	@echo "** make clean    : clean all compiled data"
	@echo "** make build    : build the design"
	@echo "** make build_cov: build the design in coverage mode"
	@echo "** make run      : run simulation"
	@echo "** make run_cov  : run simulation in coverage mode"
	@echo "** make all      : build and run simulation"
	@echo "** make all_cov  : build and run simulation in coverage mode"
	@echo "** make wave     : open waveform"
	@echo "** make gen_cov  : merge, generate coverage data base and text coverage report"
	@echo "** make gen_cov  : merge, gemerate coverage data base and html coverage report"
	@echo "****************************************"
	@echo ""
