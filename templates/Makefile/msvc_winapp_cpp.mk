!if "$(CRTDLL)" == "true"
CRTLIB = /MD$(DBG_SUFFIX)
!else
CRTLIB = /MT$(DBG_SUFFIX)
!endif

!if "$(DEBUG)" == "true"
DBG_SUFFIX  = d
COPTFLAGS   = /Od /GS /Zi $(CRTLIB)
LDOPTFLAGS  = /Od /GS /Zi $(CRTLIB)
MSVC_MACROS = /D_CRTDBG_MAP_ALLOC /D_USE_MATH_DEFINES
!else
DBG_SUFFIX  =
COPTFLAGS   = /Ox /GL $(CRTLIB)
LDOPTFLAGS  = /Ox /GL $(CRTLIB)
MSVC_MACROS = /DNDEBUG /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS \
              /D_USE_MATH_DEFINES
!endif

CPP      = cl
RM       = del /F
MACROS   = /DDISABLE_PRAGMA_LINK $(MSVC_MACROS)
CPPFLAGS = /nologo $(COPTFLAGS) /EHsc /W4 /c
LDFLAGS  = /nologo $(LDOPTFLAGS)
LDLIBS   = /link gdi32.lib user32.lib
TARGET   = winapp.exe
OBJ      = $(TARGET:.exe=.obj)
SRC      = $(TARGET:.exe=.cpp)


.SUFFIXES: .cpp .obj .exe
.obj.exe:
	$(CPP) $(LDFLAGS) $** /Fe$@ $(LDLIBS)


all: $(TARGET)

$(OBJ): $(SRC)


clean:
	$(RM) $(TARGET) $(OBJ)
cleanobj:
	$(RM) $(OBJ)
