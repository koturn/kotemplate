LISP      := clisp
MKDIR     := mkdir -p
CP        := cp
RM        := rm -f
LISPFLAGS := --silent
TARGET    := <+CURSOR+>
TOPLEVEL  := main
SRCS      := $(addsuffix .lisp,$(basename $(TARGET)))
OBJS      := $(SRCS:.lisp=.fas)

ENTRY_POINT  := entry-point
COMPILE_FORM := \
"(progn \
   (load \"$(OBJS)\") \
   (defun $(ENTRY_POINT) () \
     (progn \
       ($(TOPLEVEL)) \
       (ext:exit))) \
   (ext:saveinitmem \"$(TARGET)\" \
                    :quiet t \
                    :norc t \
                    :init-function \
                    \#'$(ENTRY_POINT) \
                    :executable t))"

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe,$(TARGET))
else
    TARGET := $(addsuffix .out,$(TARGET))
endif
INSTALLED_TARGET := $(if $(PREFIX),$(PREFIX),/usr/local)/bin/$(TARGET)

%.exe:
	$(LISP) $(LISPFLAGS) -x $(COMPILE_FORM)
%.out:
	$(LISP) $(LISPFLAGS) -x $(COMPILE_FORM)
%.fas:
	$(LISP) $(LISPFLAGS) -c $(filter %.lisp,$<)


.PHONY: all test install uninstall clean cleanobj
all: $(TARGET)
$(TARGET): $(OBJS)

$(foreach SRC,$(SRCS),$(eval $(SRC:.lisp=.fas): $(SRC)))

test: $(TARGET)
	@./$<

install: $(INSTALLED_TARGET)
$(INSTALLED_TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET)

clean:
	$(RM) $(TARGET) $(OBJS) $(OBJS:.fas=.lib)

cleanobj:
	$(RM) $(OBJS) $(OBJS:.fas=.lib)
