MAKE     ?= make
DIR_LIST := apple/ banana/ cake/
<+CURSOR+>

.PHONY: all clean cleanobj
all:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir; \
	done

clean:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir $@; \
	done

cleanobj:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir $@; \
	done
