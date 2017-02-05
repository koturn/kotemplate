### This Makefile was written for GNU Make. ###
ifeq ($(DEBUG),true)
    OPT_CFLAGS  := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
ifneq ($(shell echo $$OSTYPE),cygwin)
    OPT_CFLAGS  := $(OPT_CFLAGS) -fsanitize=address -fno-omit-frame-pointer
endif
    OPT_LDLIBS  := -lssp
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
    OPT_CFLAGS  := $(OPT_CFLAGS) -fopenmp
    OPT_LDFLAGS := $(OPT_LDFLAGS) -fopenmp
else
    OPT_CFLAGS  := $(OPT_CFLAGS) -Wno-unknown-pragmas
endif

WARNING_COMMON_FLAGS := \
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
    -Wsuggest-final-methods \
    -Wsuggest-final-types \
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
    -Wtraditional \
    -Wtraditional-conversion \
    -Wunsuffixed-float-constants \
    -pedantic

CC         := gcc $(if $(STDC),$(addprefix -std=,$(STDC)),-std=gnu11)
MKDIR      := mkdir -p
CP         := cp
RM         := rm -f
CTAGS      := ctags
# MACROS   := MACRO
# INCDIRS  := ./include
CPPFLAGS   := $(addprefix -D,$(MACROS)) $(addprefix -I,$(INCDIRS))
CFLAGS     := -pipe $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
LDFLAGS    := -pipe $(OPT_LDFLAGS)
CTAGSFLAGS := -R --languages=c
LDLIBS     := $(OPT_LDLIBS)
TARGET     := <+CURSOR+>
SRCS       := $(addsuffix .c,$(basename $(TARGET)))
OBJS       := $(SRCS:.c=.o)
DEPENDS    := depends.mk

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


.PHONY: all test depends syntax ctags install uninstall clean cleanobj
all: $(TARGET)
$(TARGET): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(filter-out \,$(shell $(CC) -MM $(SRC)))))

test: $(TARGET)
	@./$<

depends:
	$(CC) -MM $(SRCS) > $(DEPENDS)

syntax:
	$(CC) $(SRCS) -fsyntax-only $(WARNING_CFLAGS) $(INCS) $(MACROS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

install: $(INSTALLED_TARGET)
$(INSTALLED_TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET)

clean:
	$(RM) $(TARGET) $(OBJS)

cleanobj:
	$(RM) $(OBJS)
