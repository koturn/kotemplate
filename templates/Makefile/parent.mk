MAKE     ?= make
DIR_LIST := apple/ banana/ cake/
<+CURSOR+>


define default-rule
$1:
	@for dir in $(DIR_LIST); do \
		$(MAKE) -C $$$$dir $$@; \
	done
endef


PHONY_TARGETS := all clean cleanobj
.PHONY: $(PHONY_TARGETS)

$(foreach TARGET, $(SIMPLE_TARGETS), $(eval $(call default-rule, $(TARGET))))
