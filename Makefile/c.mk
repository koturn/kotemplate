### This Makefile was written for GNU Make. ### ifeq ($(DEBUG),true)
ifeq ($(DEBUG),true)
    OPT_CFLAGS  := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
    OPT_LDLIBS  := -lssp
ifneq ($(shell echo $$OSTYPE),cygwin)
    OPT_CFLAGS  += -fsanitize=address -fno-omit-frame-pointer
    OPT_LDLIBS  += -fsanitize=address
endif
else
ifeq ($(OPT),true)
    OPT_CFLAGS  := -flto -Ofast -march=native -DNDEBUG
    OPT_LDFLAGS := -flto -s
else
ifeq ($(LTO),true)
    OPT_CFLAGS  := -flto -DNDEBUG
    OPT_LDFLAGS := -flto
else
    OPT_CFLAGS  := -O3 -DNDEBUG
    OPT_LDFLAGS := -s
endif
endif
endif

ifeq ($(OMP),true)
    OPT_CFLAGS  += -fopenmp
    OPT_LDFLAGS += -fopenmp
else
    OPT_CFLAGS  += -Wno-unknown-pragmas
endif

WARNING_CFLAGS := \
    -Wall \
    -Wextra \
    -Wabi \
    -Wcast-align \
    -Wcast-qual \
    -Wconversion \
    -Wdisabled-optimization \
    -Wdouble-promotion \
    -Wfloat-equal \
    -Wformat=2 \
    -Winit-self \
    -Winline \
    -Wlogical-op \
    -Wmissing-declarations \
    -Wno-return-local-addr \
    -Wpointer-arith \
    -Wredundant-decls \
    -Wstrict-aliasing=2 \
    -Wsuggest-attribute=const \
    -Wsuggest-attribute=format \
    -Wsuggest-attribute=noreturn \
    -Wsuggest-attribute=pure \
    -Wswitch-enum \
    -Wundef \
    -Wunsafe-loop-optimizations \
    -Wunreachable-code \
    -Wvector-operation-performance \
    -Wwrite-strings \
    -Wc++-compat \
    -Wbad-function-cast \
    -Wjump-misses-init \
    -Wmissing-prototypes \
    -Wunsuffixed-float-constants \
    -pedantic

CC           := gcc $(if $(STDC),$(addprefix -std=,$(STDC)),-std=gnu11)
MKDIR        := mkdir -p
CP           := cp
RM           := rm -f
CTAGS        := ctags
DOXYGEN      := doxygen
DOXYFILE     := Doxyfile
DOXYGENDISTS := doxygen_sqlite3.db html/ latex/
# MACROS     := MACRO
# INCDIRS    := ./include
CPPFLAGS     := $(addprefix -D,$(MACROS)) $(addprefix -I,$(INCDIRS))
CFLAGS       := -pipe $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
LDFLAGS      := -pipe $(OPT_LDFLAGS)
CTAGSFLAGS   := -R --languages=c
LDLIBS       := $(OPT_LDLIBS)
TARGET       := <+CURSOR+>
SRCS         := $(addsuffix .c,$(basename $(TARGET)))
OBJS         := $(SRCS:.c=.o)
DEPENDS      := depends.mk

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe,$(TARGET))
else
    TARGET := $(addsuffix .out,$(TARGET))
endif
INSTALLED_TARGET := $(if $(PREFIX),$(PREFIX),/usr/local)/bin/$(TARGET)

%.exe:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@
%.out:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@


.PHONY: all test depends asm syntax ctags doxygen install uninstall clean distclean
all: $(TARGET)
$(TARGET): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(filter-out \,$(shell $(CC) -MM $(SRC)))))

test: $(TARGET)
	@./$<

depends:
	$(CC) -MM $(SRCS) > $(DEPENDS)

asm:
	$(CC) $(SRCS) -S --verbose-asm $(CPPFLAGS) $(CFLAGS)

syntax:
	$(CC) $(SRCS) -fsyntax-only $(CPPFLAGS) $(WARNING_CFLAGS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

doxygen: $(DOXYFILE)
	$(DOXYGEN) $<

$(DOXYFILE):
	$(DOXYGEN) -g $@

install: $(INSTALLED_TARGET)
$(INSTALLED_TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET)

clean:
	$(RM) $(OBJS)

distclean:
	$(RM) $(TARGET) $(OBJS) $(DOXYGENDISTS)
