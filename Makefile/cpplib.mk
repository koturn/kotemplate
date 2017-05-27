### This Makefile was written for GNU Make. ###
ifeq ($(DEBUG),true)
    OPT_CFLAGS   := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
    OPT_LDLIBS   := -lssp
ifneq ($(shell echo $$OSTYPE),cygwin)
    OPT_CFLAGS   += -fsanitize=address -fno-omit-frame-pointer
    OPT_LDLIBS   += -fsanitize=address
endif
    OPT_CXXFLAGS := $(OPT_CFLAGS) -D_GLIBCXX_DEBUG
else
ifeq ($(OPT),true)
    OPT_CFLAGS   := -flto -Ofast -march=native -DNDEBUG
    OPT_CXXFLAGS := $(OPT_CFLAGS)
    OPT_LDFLAGS  := -flto -s
else
ifeq ($(LTO),true)
    OPT_CFLAGS   := -flto -DNDEBUG
    OPT_CXXFLAGS := $(OPT_CFLAGS)
    OPT_LDFLAGS  := -flto
else
    OPT_CFLAGS   := -O3 -DNDEBUG
    OPT_CXXFLAGS := $(OPT_CFLAGS)
    OPT_LDFLAGS  := -s
endif
endif
endif

ifeq ($(OMP),true)
    OPT_CFLAGS   += -fopenmp
    OPT_CXXFLAGS += -fopenmp
    OPT_LDFLAGS  += -fopenmp
else
    OPT_CFLAGS   += -Wno-unknown-pragmas
    OPT_CXXFLAGS += -Wno-unknown-pragmas
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
    -pedantic

WARNING_CFLAGS := \
    $(WARNING_COMMON_FLAGS) \
    -Wc++-compat \
    -Wbad-function-cast \
    -Wjump-misses-init \
    -Wmissing-prototypes \
    -Wunsuffixed-float-constants

WARNING_CXXFLAGS := \
    $(WARNING_COMMON_FLAGS) \
    -Wc++11-compat \
    -Wc++14-compat \
    -Weffc++ \
    -Woverloaded-virtual \
    -Wsign-promo \
    -Wstrict-null-sentinel \
    -Wsuggest-override \
    -Wuseless-cast \
    -Wzero-as-null-pointer-constant

SHARED_FLAGS := -shared
ifneq ($(OS),Windows_NT)
    SHARED_FLAGS += $(SHARED_FLAGS) -fPIC
endif

CC           := gcc $(if $(STDC),$(addprefix -std=,$(STDC)),-std=gnu11)
CXX          := g++ $(if $(STDCXX),$(addprefix -std=,$(STDCXX)),-std=gnu++14)
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
CFLAGS       := -pipe -fvisibility=hidden $(SHARED_FLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS)
CXXFLAGS     := -pipe -fvisibility=hidden -fvisibility-inlines-hidden $(SHARED_FLAGS) $(WARNING_CXXFLAGS) $(OPT_CXXFLAGS)
LDFLAGS      := -pipe $(SHARED_FLAGS) $(OPT_LDFLAGS)
LDLIBS       := $(OPT_LDLIBS)
ARFLAGS      := crsv
CTAGSFLAGS   := -R --languages=c,c++
BASENAME     := <+CURSOR+>
SRCS         := $(addsuffix .cpp,$(basename $(BASENAME)))
OBJS         := $(foreach PAT,%.cpp %.cxx %.cc,$(patsubst $(PAT),%.o,$(filter $(PAT),$(SRCS))))
PREFIX       := /usr/local
DEPENDS      := depends.mk

ifeq ($(OS),Windows_NT)
    SHARED_LIB := $(addsuffix .dll,$(BASENAME))
else
    SHARED_LIB := $(addprefix lib,$(addsuffix .so,$(BASENAME)))
endif
STATIC_LIB := $(addprefix lib,$(addsuffix .a,$(BASENAME)))
INSTALLED_SHARED_LIB := $(addprefix $(PREFIX)/bin/,$(notdir $(SHARED_LIB)))
INSTALLED_STATIC_LIB := $(addprefix $(PREFIX)/lib/,$(notdir $(STATIC_LIB)))


%.dll:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o,$^) $(LDLIBS) -o $@
%.so:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o,$^) $(LDLIBS) -o $@
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^) $(LDLIBS)


.PHONY: all shared static depends asm syntax ctags install uninstall clean distclean
all: shared
# all: static

shared: $(SHARED_LIB)
$(SHARED_LIB): $(OBJS)

static: $(STATIC_LIB)
$(STATIC_LIB): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(filter-out \,$(shell $(CXX) -MM $(SRC)))))

depends:
	$(CXX) -MM $(SRCS) > $(DEPENDS)

asm:
	$(CXX) $(SRCS) -S --verbose-asm $(CPPFLAGS) $(CXXFLAGS)

syntax:
	$(CXX) $(SRCS) -fsyntax-only $(CPPFLAGS) $(WARNING_CXXFLAGS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

doxygen: $(DOXYFILE)
	$(DOXYGEN) $<

$(DOXYFILE):
	$(DOXYGEN) -g $@

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
	$(RM) $(OBJS)

distclean:
	$(RM) $(SHARED_LIB) $(STATIC_LIB) $(OBJS) $(DOXYGENDISTS)
