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
    OPT_LDFLAGS  := -flto -Ofast -s
else
ifeq ($(LTO),true)
    OPT_CFLAGS   := -flto -DNDEBUG
    OPT_CXXFLAGS := $(OPT_CFLAGS)
    OPT_LDFLAGS  := -flto
else
    OPT_CFLAGS   := -O3 -DNDEBUG
    OPT_CXXFLAGS := $(OPT_CFLAGS)
    OPT_LDFLAGS  := -O3 -s
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

CC         := gcc $(if $(STDC), $(addprefix -std=, $(STDC)),)
CXX        := g++ $(if $(STDCXX), $(addprefix -std=, $(STDCXX)),)
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
CTAGSFLAGS := -R --languages=c,c++
TARGET     := <+CURSOR+>
SRCS       := $(addsuffix .cpp, $(basename $(TARGET)))
OBJS       := $(SRCS:.cpp=.o)
INSTALLDIR := $(if $(PREFIX), $(PREFIX),/usr/local)/lib
DEPENDS    := depends.mk

ifeq ($(OS),Windows_NT)
	SHARED_LIBS := $(addsuffix .dll, $(TARGET))
else
	SHARED_LIBS := $(addprefix lib, $(addsuffix .so, $(TARGET)))
endif
STATIC_LIBS := $(addprefix lib, $(addsuffix .a, $(TARGET)))


%.dll:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) -o $@
%.so:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) -o $@
%.a:
	$(AR) $(ARFLAGS) $@ $(filter %.o, $^)


.PHONY: all shared static depends syntax ctags install uninstall clean cleanobj
all: shared

shared: $(SHARED_LIBS)
$(SHARED_LIBS): $(OBJS)

static: $(STATIC_LIBS)
$(STATIC_LIBS): $(OBJS)

# $(OBJS): $(SRCS)


-include $(DEPENDS)

depends:
	$(CXX) -MM $(SRCS) > $(DEPENDS)

syntax:
	$(CXX) $(SRCS) $(STD_CXXFLAGS) -fsyntax-only $(WARNING_CXXFLAGS) $(INCS) $(MACROS)

ctags:
	$(CTAGS) $(CTAGSFLAGS)

install: $(INSTALLDIR)/$(TARGET)
$(INSTALLDIR)/$(TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLDIR)/$(TARGET)

clean:
	$(RM) $(TARGET) $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS)

cleanobj:
	$(RM) $(OBJS) $(SHARED_LIBS) $(STATIC_LIBS)