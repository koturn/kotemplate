### This Makefile was written for GNU Make. ###
ifeq ($(DEBUG),true)
    COPTFLAGS   := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2
    CXXOPTFLAGS := -O0 -g3 -ftrapv -fstack-protector-all -D_FORTIFY_SOURCE=2 -D_GLIBCXX_DEBUG
    LDLIBS      += -lssp
else
ifeq ($(OPT),true)
    COPTFLAGS   := -flto -Ofast -march=native -DNDEBUG
    CXXOPTFLAGS := -flto -Ofast -march=native -DNDEBUG
    LDOPTFLAGS  := -flto -Ofast -s
else
ifeq ($(LTO),true)
    COPTFLAGS   := -flto -DNDEBUG
    CXXOPTFLAGS := -flto -DNDEBUG
    LDOPTFLAGS  := -flto
else
    COPTFLAGS   := -O3 -DNDEBUG
    CXXOPTFLAGS := -O3 -DNDEBUG
    LDOPTFLAGS  := -O3 -s
endif
endif
endif

ifeq ($(OMP),true)
    COPTFLAGS   := -fopenmp
    CXXOPTFLAGS := -fopenmp
    LDOPTFLAGS  := -fopenmp
else
    COPTFLAGS   := -Wno-unknown-pragmas
    CXXOPTFLAGS := -Wno-unknown-pragmas
endif

C_WARNING_FLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                   -Wcast-align -Wcast-qual -Wconversion \
                   -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                   -Wwrite-strings -pedantic
CXX_WARNING_FLAGS := $(C_WARNING_FLAGS) -Weffc++ -Woverloaded-virtual

CC       := gcc
CXX      := g++
# MACROS   := -DMACRO
# INCS     := -I./include
CFLAGS   := -pipe $(C_WARNING_FLAGS)   $(COPTFLAGS)   $(INCS) $(MACROS) $(if $(STD), $(addprefix -std=, $(STD)),)
CXXFLAGS := -pipe $(CXX_WARNING_FLAGS) $(CXXOPTFLAGS) $(INCS) $(MACROS) $(if $(STD), $(addprefix -std=, $(STD)),)
LDFLAGS  := -pipe $(LDOPTFLAGS)
# LDLIBS   := -lm
TARGET   := template
OBJ      := $(addsuffix .o, $(basename $(TARGET)))
SRC      := $(OBJ:%.o=%.cpp)

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

%.exe:
	$(CXX) $(LDFLAGS) $(filter %.c %.cc %.cpp %.cxx %.o, $^) $(LDLIBS) -o $@
%.out:
	$(CXX) $(LDFLAGS) $(filter %.c %.cc %.cpp %.cxx %.o, $^) $(LDLIBS) -o $@


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
