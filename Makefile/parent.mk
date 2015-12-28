MAKE     ?= make
DIR_LIST := apple/ banana/ cake/
<+CURSOR+>

.PHONY: all
all:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir; \
	done

.PHONY: clean
clean:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir $@; \
	done

.PHONY: cleanobj
cleanobj:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir $@; \
	done
