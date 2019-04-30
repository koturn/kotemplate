LISP      := ccl
MKDIR     := mkdir -p
CP        := cp
RM        := rm -f
LISPFLAGS := -no-init --quiet
TARGET    := <+CURSOR+>
TOPLEVEL  := main
SRCS      := $(addsuffix .lisp,$(basename $(TARGET)))

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe,$(TARGET))
else
    TARGET := $(addsuffix .out,$(TARGET))
endif
INSTALLED_TARGET := $(if $(PREFIX),$(PREFIX),/usr/local)/bin/$(TARGET)

COMPILE_FORM := \
"(ccl:save-application \"$(TARGET)\" \
                       :toplevel-function \#'$(TOPLEVEL) \
                       :prepend-kernel t)"


%.exe:
	$(LISP) --load $(SRCS) --eval $(COMPILE_FORM)
%.out:
	$(LISP) --load $(SRCS) --eval $(COMPILE_FORM)


.PHONY: all test install uninstall clean cleanobj
all: $(TARGET)
$(TARGET): $(SRCS)

test: $(TARGET)
	@./$<

install: $(INSTALLED_TARGET)
$(INSTALLED_TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET)

clean:
	$(RM) $(TARGET)
