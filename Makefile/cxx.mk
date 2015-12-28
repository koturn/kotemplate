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

CC       := g++
CXX      := g++
# MACROS   := -DMACRO
# INCS     := -I./include
CFLAGS   := -pipe $(WARNING_CFLAGS)   $(OPT_CFLAGS)   $(INCS) $(MACROS) $(if $(STD), $(addprefix -std=, $(STD)),)
CXXFLAGS := -pipe $(WARNING_CXXFLAGS) $(OPT_CXXFLAGS) $(INCS) $(MACROS) $(if $(STD), $(addprefix -std=, $(STD)),)
LDFLAGS  := -pipe $(OPT_LDFLAGS)
LDLIBS   := $(OPT_LDLIBS)
TARGET   := <+CURSOR+>
OBJ      := $(addsuffix .o, $(basename $(TARGET)))
SRC      := $(OBJ:.o=.cpp)

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

.SUFFIXES: .exe .o .out
.o.exe:
	$(CXX) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@
.o.out:
	$(CXX) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@
.o:
	$(CXX) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@


.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJ)

$(OBJ): $(SRC)


.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJ)

.PHONY: cleanobj
cleanobj:
	$(RM) $(OBJ)
