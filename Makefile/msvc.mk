### This Makefile was written for nmake. ###
!if "$(CRTDLL)" == "true"
CRTLIB = /MD$(DBG_SUFFIX)
!else
CRTLIB = /MT$(DBG_SUFFIX)
!endif

!if "$(DEBUG)" == "true"
COPTFLAGS   = /Od /GS /Zi $(CRTLIB)
LDOPTFLAGS  = /Od /GS /Zi $(CRTLIB)
MSVC_MACROS = /D_DEBUG /D_CRTDBG_MAP_ALLOC /D_USE_MATH_DEFINES
DBG_SUFFIX  = d
!else
COPTFLAGS   = /Ox /GL $(CRTLIB)
LDOPTFLAGS  = /Ox /GL $(CRTLIB)
MSVC_MACROS = /DNDEBUG /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS \
              /D_USE_MATH_DEFINES
DBG_SUFFIX  =
!endif

CC       = cl
RM       = del /F
# MAKE     = $(MAKE) /nologo
# GIT      = git
# INCS     =
MACROS   = $(MSVC_MACROS)
CFLAGS   = /nologo $(COPTFLAGS) /W4 /c $(INCS) $(MACROS)
LDFLAGS  = /nologo $(LDOPTFLAGS)
# LDLIBS   =
TARGET   = template.exe
OBJ      = $(TARGET:.exe=.obj)
SRC      = $(TARGET:.exe=.c)
# MAKEFILE = msvc.mk


.SUFFIXES: .c .obj .exe
.obj.exe:
	$(CC) $(LDFLAGS) $** /Fe$@ /link $(LDLIBS)
.c.obj:
	$(CC) $(CFLAGS) $** /Fo$@


all: $(DEPENDENT_LIBRARIES) $(TARGET)

$(TARGET): $(OBJ)

$(OBJ): $(SRC)


clean:
	$(RM) $(TARGET) $(OBJ)
cleanobj:
	$(RM) $(OBJ)
