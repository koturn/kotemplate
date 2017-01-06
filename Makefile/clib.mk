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
    OPT_LDFLAGS := -flto -Ofast -s
else
ifeq ($(LTO),true)
    OPT_CFLAGS  := -flto -DNDEBUG
    OPT_LDFLAGS := -flto
else
    OPT_CFLAGS  := -O3 -DNDEBUG
    OPT_LDFLAGS := -O3 -s
endif
endif
endif

ifeq ($(OMP),true)
    OPT_CFLAGS  := $(OPT_CFLAGS) -fopenmp
    OPT_LDFLAGS := $(OPT_LDFLAGS) -fopenmp
else
    OPT_CFLAGS  := $(OPT_CFLAGS) -Wno-unknown-pragmas
endif

WARNING_CFLAGS := \
    -Wall \
    -Wextra \
    -Wcast-align \
    -Wcast-qual \
    -Wconversion \
    -Wfloat-equal \
    -Wformat=2 \
    -Wpointer-arith \
    -Wstrict-aliasing=2 \
    -Wswitch-enum \
    -Wwrite-strings \
    -pedantic

SHARED_FLAGS := -shared
ifneq ($(OS),Windows_NT)
	SHARED_FLAGS := $(SHARED_FLAGS) -fPIC
endif

CC         := gcc $(if $(STDC),$(addprefix -std=,$(STDC)),-std=gnu11)
AR         := ar
MKDIR      := mkdir -p
CP         := cp
RM         := rm -f
CTAGS      := ctags
# MACROS   := MACRO
# INCDIRS  := ./include
CPPFLAGS   := $(addprefix -D,$(MACROS)) $(addprefix -I,$(INCDIRS))
CFLAGS     := -pipe $(SHARED_FLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS)
LDFLAGS    := -pipe $(SHARED_FLAGS) $(OPT_LDFLAGS)
ARFLAGS    := crsv
CTAGSFLAGS := -R --languages=c
LDLIBS     := $(OPT_LDLIBS)
BASENAME   := <+CURSOR+>
SRCS       := $(addsuffix .c,$(basename $(BASENAME)))
OBJS       := $(SRCS:.c=.o)
PREFIX     := /usr/local
DEPENDS    := depends.mk

ifeq ($(OS),Windows_NT)
	SHARED_LIBS := $(addsuffix .dll,$(BASENAME))
else
	SHARED_LIBS := $(addprefix lib,$(addsuffix .so,$(BASENAME)))
endif
STATIC_LIBS := $(addprefix lib,$(addsuffix .a,$(BASENAME)))
INSTALLED_SHARED_LIB := $(addprefix $(PREFIX)/bin/,$(notdir $(SHARED_LIB)))
INSTALLED_STATIC_LIB := $(addprefix $(PREFIX)/lib/,$(notdir $(STATIC_LIB)))


%.dll:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@
%.so:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^) $(LDLIBS)


.PHONY: all shared static depends syntax ctags install uninstall clean cleanobj
all: shared static

shared: $(SHARED_LIBS)
$(SHARED_LIBS): $(OBJS)

static: $(STATIC_LIBS)
$(STATIC_LIBS): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(filter-out \,$(shell $(CC) -MM $(SRC)))))

depends:
	$(CC) -MM $(SRCS) > $(DEPENDS)

syntax:
	$(CC) $(SRCS) $(STD_CFLAGS) -fsyntax-only $(WARNING_CFLAGS) $(INCS) $(MACROS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

install: $(INSTALLED_SHARED_LIB) $(INSTALLED_STATIC_LIB)

$(INSTALLED_SHARED_LIB): $(SHARED_LIB)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

$(INSTALLED_STATIC_LIB): $(STATIC_LIB)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_SHARED_LIB) $(INSTALLED_STATIC_LIB)

clean:
	$(RM) $(SHARED_LIBS) $(STATIC_LIBS) $(OBJS)

cleanobj:
	$(RM) $(SHARED_LIBS) $(STATIC_LIBS) $(OBJS)
