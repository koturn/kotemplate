### This Makefile was written for GNU Make. ###
ifeq ($(DEBUG),true)
    OPT_CFLAGS   := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
ifneq ($(shell echo $$OSTYPE),cygwin)
    OPT_CFLAGS   := $(OPT_CFLAGS) -fsanitize=address -fno-omit-frame-pointer
endif
    OPT_CXXFLAGS := $(OPT_CFLAGS) -D_GLIBCXX_DEBUG
    OPT_LDLIBS   := -lssp
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
    OPT_CFLAGS   := $(OPT_CFLAGS) -fopenmp
    OPT_CXXFLAGS := $(OPT_CXXFLAGS) -fopenmp
    OPT_LDFLAGS  := $(OPT_LDFLAGS) -fopenmp
else
    OPT_CFLAGS   := $(OPT_CFLAGS) -Wno-unknown-pragmas
    OPT_CXXFLAGS := $(OPT_CXXFLAGS) -Wno-unknown-pragmas
endif

WARNING_CFLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                  -Wcast-align -Wcast-qual -Wconversion \
                  -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                  -Wwrite-strings -pedantic
WARNING_CXXFLAGS := $(WARNING_CFLAGS) -Weffc++ -Woverloaded-virtual

SHARED_FLAGS := -shared
ifneq ($(OS),Windows_NT)
	SHARED_FLAGS := $(SHARED_FLAGS) -fPIC
endif

CC         := gcc $(if $(STDC), $(addprefix -std=, $(STDC)), -std=gnu11)
CXX        := g++ $(if $(STDCXX), $(addprefix -std=, $(STDCXX)), -std=gnu++14)
AR         := ar
MKDIR      := mkdir -p
CP         := cp
RM         := rm -f
CTAGS      := ctags
# MACROS   := -DMACRO
# INCS     := -I./include
CFLAGS     := -pipe $(SHARED_FLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
CXXFLAGS   := -pipe $(SHARED_FLAGS) $(WARNING_CXXFLAGS) $(OPT_CXXFLAGS) $(INCS) $(MACROS)
LDFLAGS    := -pipe $(SHARED_FLAGS) $(OPT_LDFLAGS)
LDLIBS     := $(OPT_LDLIBS)
ARFLAGS    := crsv
CTAGSFLAGS := -R --languages=c,c++
BASENAME   := <+CURSOR+>
OBJS       := $(addsuffix .o, $(basename $(BASENAME)))
SRCS       := $(OBJS:.o=.cpp)
PREFIX     := /usr/local
DEPENDS    := depends.mk

ifeq ($(OS),Windows_NT)
	SHARED_LIB := $(addsuffix .dll, $(BASENAME))
else
	SHARED_LIB := $(addprefix lib, $(addsuffix .so, $(BASENAME)))
endif
STATIC_LIB := $(addprefix lib, $(addsuffix .a, $(BASENAME)))
INSTALLED_SHARED_LIB := $(addprefix $(PREFIX)/bin/,$(notdir $(SHARED_LIB)))
INSTALLED_STATIC_LIB := $(addprefix $(PREFIX)/lib/,$(notdir $(STATIC_LIB)))


%.dll:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) -o $@
%.so:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) -o $@
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o, $^)


.PHONY: all shared static depends syntax ctags install uninstall clean cleanobj
all: shared static

shared: $(SHARED_LIB)
$(SHARED_LIB): $(OBJS)

static: $(STATIC_LIB)
$(STATIC_LIB): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(subst \,,$(shell $(CXX) -MM $(SRC)))))

depends:
	$(CXX) -MM $(SRCS) > $(DEPENDS)

syntax:
	$(CXX) $(SRCS) $(STD_CXXFLAGS) -fsyntax-only $(WARNING_CXXFLAGS) $(INCS) $(MACROS)

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
	$(RM) $(SHARED_LIB) $(STATIC_LIB) $(OBJS)

cleanobj:
	$(RM) $(SHARED_LIB) $(STATIC_LIB) $(OBJS)
