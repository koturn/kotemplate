LISP      := sbcl
MKDIR     := mkdir -p
CP        := cp
RM        := rm -f
LISPFLAGS := --quit
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
"(sb-ext:save-lisp-and-die \"$(TARGET)\" \
                           :executable t \
                           :toplevel \
                           \#'$(TOPLEVEL) \
                           :purify t)"

%.exe:
	$(LISP) $(LISPFLAGS) --load $(SRCS) --eval $(COMPILE_FORM)
%.out:
	$(LISP) $(LISPFLAGS) --load $(SRCS) --eval $(COMPILE_FORM)


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
