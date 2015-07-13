MAKE     ?= make
DIR_LIST := apple/ banana/ cake/


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
objclean:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$dir $@; \
	done
