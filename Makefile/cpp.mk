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


CC           := gcc $(if $(STDC), $(addprefix -std=, $(STDC)),-std=gnu11)
CXX          := g++ $(if $(STDCXX), $(addprefix -std=, $(STDCXX)),-std=gnu++14)
MKDIR        := mkdir -p
CP           := cp
RM           := rm -f
CTAGS        := ctags
# MACROS       := -DMACRO
# INCS         := -I./include
CFLAGS       := -pipe $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
CXXFLAGS     := -pipe $(WARNING_CXXFLAGS) $(OPT_CXXFLAGS) $(INCS) $(MACROS)
LDFLAGS      := -pipe $(OPT_LDFLAGS)
LDLIBS       := $(OPT_LDLIBS)
CTAGSFLAGS   := -R --languages=c,c++
TARGET       := <+CURSOR+>
OBJS         := $(addsuffix .o, $(basename $(TARGET)))
SRCS         := $(SRCS:.o=.cpp)
INSTALLDIR   := $(if $(PREFIX), $(PREFIX),/usr/local)/bin
DEPENDS      := depends.mk

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

%.exe:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) $(LDLIBS) -o $@
%.out:
	$(CXX) $(LDFLAGS) $(filter %.c %.cpp %.cxx %.cc %.o, $^) $(LDLIBS) -o $@


.PHONY: all depends syntax ctags install uninstall clean cleanobj
all: $(TARGET)
$(TARGET): $(OBJS)

# $(OBJS): $(SRCS)
# -include $(DEPENDS)
$(foreach SRC,$(SRCS),$(eval $(subst \,,$(shell $(CXX) -MM $(SRC)))))

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
	$(RM) $(TARGET) $(OBJS)

cleanobj:
	$(RM) $(OBJS)
