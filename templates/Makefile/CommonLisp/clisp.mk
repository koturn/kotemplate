LISP      := clisp
MKDIR     := mkdir -p
CP        := cp
RM        := rm -f
LISPFLAGS := -norc --quiet -on-error exit
TARGET    := <+CURSOR+>
TOPLEVEL  := main
SRCS      := $(addsuffix .lisp,$(basename $(TARGET)))
OBJS      := $(SRCS:.lisp=.fas)

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe,$(TARGET))
else
    TARGET := $(addsuffix .out,$(TARGET))
endif
INSTALLED_TARGET := $(if $(PREFIX),$(PREFIX),/usr/local)/bin/$(TARGET)

ENTRY_POINT  := entry-point
COMPILE_FORM := \
"(progn \
   (load \"$(OBJS)\") \
   (defun $(ENTRY_POINT) () \
     (declare (optimize (debug 0) (safety 0) (space 0) (speed 3))) \
     (progn \
       ($(TOPLEVEL)) \
       (ext:exit))) \
   (ext:saveinitmem \"$(TARGET)\" \
                    :quiet t \
                    :norc t \
                    :init-function \
                    \#'$(ENTRY_POINT) \
                    :executable t))"


%.exe:
	$(LISP) $(LISPFLAGS) -x $(COMPILE_FORM)
%.out:
	$(LISP) $(LISPFLAGS) -x $(COMPILE_FORM)
%.fas %.lib: %.lisp
	$(LISP) $(LISPFLAGS) -c $(filter %.lisp,$<)


.PHONY: all test install uninstall clean cleanobj
all: $(TARGET)
$(TARGET): $(OBJS)

$(foreach SRC,$(SRCS),$(eval $(SRC:.lisp=.fas) $(SRC:.lisp=.lib): $(SRC)))

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
