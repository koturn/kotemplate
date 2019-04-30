### This Makefile was written for GNU Make. ###
LIBTYPE := shared
# LIBTYPE := static

ifeq ($(DEBUG),true)
    OPT_CFLAGS := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
    OPT_LDLIBS := -lssp
    ifneq ($(shell echo $$OSTYPE),cygwin)
        OPT_CFLAGS += -fsanitize=address -fno-omit-frame-pointer
        OPT_LDLIBS += -fsanitize=address
    endif
else
    ifeq ($(OPT),true)
        OPT_CFLAGS := -flto -Ofast -march=native -DNDEBUG
        OPT_LDFLAGS := -flto -s
    else
        ifeq ($(LTO),true)
            OPT_CFLAGS := -flto -DNDEBUG
            OPT_LDFLAGS := -flto
        else
            OPT_CFLAGS := -O3 -DNDEBUG
            OPT_LDFLAGS := -s
        endif
    endif
endif

ifeq ($(OMP),true)
    OPT_CFLAGS += -fopenmp
    OPT_LDFLAGS += -fopenmp
else
    OPT_CFLAGS += -Wno-unknown-pragmas
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

ifeq ($(LIBTYPE),shared)
    SHARED_CFLAGS := -fvisibility=hidden
    ifneq ($(OS),Windows_NT)
        SHARED_CFLAGS := -fPIC $(SHARED_CFLAGS)
    endif
    SHARED_LDFLAGS := -shared
endif


CC           := gcc $(if $(STDC),$(addprefix -std=,$(STDC)),-std=gnu11)
AR           := ar
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
CFLAGS       := -pipe $(SHARED_CFLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS)
LDFLAGS      := -pipe $(SHARED_LDFLAGS) $(OPT_LDFLAGS)
ARFLAGS      := crsv
CTAGSFLAGS   := -R --languages=c
LDLIBS       := $(OPT_LDLIBS)
BASENAME     := <+CURSOR+>
SRCS         := $(addsuffix .c,$(basename $(BASENAME)))
OBJS         := $(SRCS:.c=.o)
PREFIX       := /usr/local
DEPENDS      := depends.mk

ifeq ($(OS),Windows_NT)
    SHARED_LIBS := $(addsuffix .dll,$(BASENAME))
else
    SHARED_LIBS := $(addprefix lib,$(addsuffix .so,$(BASENAME)))
endif
STATIC_LIBS := $(addprefix lib,$(addsuffix .a,$(BASENAME)))
INSTALLED_SHARED_LIB := $(addprefix $(PREFIX)/bin/,$(notdir $(SHARED_LIB)))
INSTALLED_STATIC_LIB := $(addprefix $(PREFIX)/lib/,$(notdir $(STATIC_LIB)))

ifeq ($(LIBTYPE),shared)
    TARGET_LIB := $(SHARED_LIB)
    INSTALLED_TARGET_LIB := $(INSTALLED_SHARED_LIB)
else
    TARGET_LIB := $(STATIC_LIB)
    INSTALLED_TARGET_LIB := $(INSTALLED_STATIC_LIB)
endif


%.dll:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@
%.so:
	$(CC) $(LDFLAGS) $(filter %.c %.o,$^) $(LDLIBS) -o $@
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^) $(LDLIBS)


.PHONY: all depends asm syntax ctags doxygen install uninstall clean distclean
all: $(TARGET_LIB)

$(TARGET_LIB): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(filter-out \,$(shell $(CC) -MM $(SRC)))))

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

install: $(INSTALLED_TARGET_LIB)

$(INSTALLED_TARGET_LIB): $(TARGET_LIB)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET_LIB)

clean:
	$(RM) $(OBJS)

distclean:
	$(RM) $(TARGET_LIB) $(OBJS) $(DOXYGENDISTS)
