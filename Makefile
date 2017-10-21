# Comment/uncomment the following line to disable/enable debugging
DEBUG = y

# Add your debugging flag (or not) to CFLAGS
ifeq ($(DEBUG), y)
   DEBFLAGS = -O -g -DSCULL_DEBUG # "-O" is needed to expand inlines
else
   DEBFLAGS = -O2
endif
 
EXTRA_CFLAGS += $(DEBFLAGS) -I$(LDDINC)
 
ifneq ($(KERNELRELEASE),)
   # call from kernel build system
   scull-objs := main.o pipe.o access.o
   obj-m   := scull.o
else
   KERNELDIR ?= /lib/modules/$(shell uname -r)/build
   PWD       := $(shell pwd)
modules:
	echo $(MAKE) -C $(KERNELDIR) M=$(PWD) LDDINC=$(PWD)/../include modules
	$(MAKE) -C $(KERNELDIR) M=$(PWD) LDDINC=$(PWD)/../include modules
endif

clean:	
	rm -rf *.o *~ core .depend *.mod.o .*.cmd *.ko *.mod.c \
	.tmp_versions *.markers *.symvers modules.order a.out sculltest

depend .depend dep:
	$(CC) $(CFLAGS) -M *.c > .depend

ifeq (.depend,$(wildcard .depend))
	include .depend
endif
