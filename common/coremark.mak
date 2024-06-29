#=======================================================================
# UCB VLSI FLOW: Makefile for riscv-bmarks
#-----------------------------------------------------------------------
# Yunsup Lee (yunsup@cs.berkeley.edu)
#

XLEN ?= 32

default: all

src_dir = .

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -O3 -fno-common -funroll-loops -finline-functions -falign-functions=16 -falign-jumps=4 -falign-loops=4 -finline-limit=1000 -fno-if-conversion2 -fselective-scheduling -fno-tree-dominator-opts -fno-tree-loop-distribute-patterns -Wno-implicit
RISCV_LINK ?= $(RISCV_GCC) -T $(src_dir)/common/test.ld
RISCV_LINK_OPTS ?= -static -nostartfiles -lm -lgcc -T $(src_dir)/common/test.ld
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

incs  += -I$(src_dir)/common -I$(src_dir)
objs  :=

RISCV_GCC_OPTS += -DPERFORMANCE_RUN=1 -DITERATIONS=10 -DMAIN_HAS_NOARGC=1 -DMAIN_HAS_NORETURN=1 -DHAS_FLOAT=0 -DFLAGS_STR=\"\"

coremark.riscv: $(wildcard $(src_dir)/*) $(wildcard $(src_dir)/common/*)
	$(RISCV_GCC) $(incs) $(RISCV_GCC_OPTS) -o $@ $(wildcard $(src_dir)/*.c) $(wildcard $(src_dir)/*.S) $(wildcard $(src_dir)/common/*.c) $(wildcard $(src_dir)/common/*.S) $(RISCV_LINK_OPTS)

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

coremark.riscv.dump: %.riscv.dump: %.riscv
	$(RISCV_OBJDUMP) $< > $@

junk += coremark.riscv coremark.riscv.dump

#------------------------------------------------------------
# Default

all: coremark.riscv.dump

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk)


