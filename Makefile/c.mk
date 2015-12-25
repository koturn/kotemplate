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
    OPT_CFLAGS  := -fopenmp
    OPT_LDFLAGS := -fopenmp
else
    OPT_CFLAGS  := -Wno-unknown-pragmas
endif

WARNING_CFLAGS := -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2 \
                  -Wcast-align -Wcast-qual -Wconversion \
                  -Wfloat-equal -Wpointer-arith -Wswitch-enum \
                  -Wwrite-strings -pedantic

CC       := gcc
# MACROS   := -DMACRO
# INCS     := -I./include
CFLAGS   := -pipe $(WARNING_CFLAGS) $(OPT_CFLAGS) $(INCS) $(MACROS) $(if $(STD), $(addprefix -std=, $(STD)),)
LDFLAGS  := -pipe $(OPT_LDFLAGS)
LDLIBS   := $(OPT_LDLIBS)
TARGET   := template
OBJ      := $(addsuffix .o, $(basename $(TARGET)))
SRC      := $(OBJ:.o=.c)

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

.SUFFIXES: .exe .o .out
.o.exe:
	$(CC) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@
.o.out:
	$(CC) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@
.o:
	$(CC) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@


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
