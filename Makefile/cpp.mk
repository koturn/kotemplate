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


CC           := gcc
CXX          := g++
RM           := rm -f
CTAGS        := ctags
# MACROS       := -DMACRO
# INCS         := -I./include
STD_CFLAGS   := $(if $(STDC), $(addprefix -std=, $(STDC)),)
STD_CXXFLAGS := $(if $(STDCXX), $(addprefix -std=, $(STDCXX)),)
CFLAGS       := -pipe $(STD_CFLAGS) $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS)
CXXFLAGS     := -pipe $(STD_CXXFLAGS) $(WARNING_CXXFLAGS) $(OPT_CXXFLAGS) $(INCS) $(MACROS)
LDFLAGS      := -pipe $(OPT_LDFLAGS)
LDLIBS       := $(OPT_LDLIBS)
CTAGSFLAGS   := -R --languages=c,c++
TARGET       := <+CURSOR+>
SRCS         := $(addsuffix .cpp, $(basename $(TARGET)))
OBJS         := $(SRCS:.cpp=.o)
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


.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJS)

# $(OBJS): $(SRCS)


-include $(DEPENDS)

.PHONY: depends
depends:
	$(CXX) -MM $(SRCS) > $(DEPENDS)


.PHONY: syntax
syntax:
	$(CXX) $(SRCS) $(STD_CXXFLAGS) -fsyntax-only $(WARNING_CXXFLAGS) $(INCS) $(MACROS)

.PHONY: ctags
ctags:
	$(CTAGS) $(CTAGSFLAGS)

.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJS)

.PHONY: cleanobj
cleanobj:
	$(RM) $(OBJS)
