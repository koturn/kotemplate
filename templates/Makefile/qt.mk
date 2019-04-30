MAKE  := make
QMAKE := qmake
MKDIR := mkdir -p
CD    := cd
CP    := cp

PROJECT_NAME := <+CURSOR+>
PROJECT_FILE := $(PROJECT_NAME).pro
PROJECT_DIR  := $(CURDIR)
BUILD_DIR    := build
MAKEFILE     := $(BUILD_DIR)/Makefile
TARGET       := $(BUILD_DIR)/$(PROJECT_NAME)
DEPENDFILES  := $(sort $(PROJECT_FILE) $(SRCS) $(wildcard *.cpp *.h *.hpp *.qrc *.ui))
CTAGS        := ctags
CTAGSFLAGS   := -R --languages=c++ \
    -Isignal \
    -Islot \
    -IQ_DECL_NOEXCEPT \
    -IQ_DECL_NOEXCEP_EXPR \
    -IQ_NORETURN \
    -IQ_DECL_FINAL \
    -IQ_DECL_OVERRIDE

ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
endif
INSTALLED_TARGET := $(if $(PREFIX), $(PREFIX),/usr/local)/bin/$(notdir $(TARGET))


.PHONY: all qmake test ctags install uninstall clean mocclean distclean
all: $(TARGET)
$(TARGET): $(MAKEFILE) $(DEPENDFILES)
	$(MAKE) -C $(BUILD_DIR) -f $(notdir $(MAKEFILE))

$(MAKEFILE): $(PROJECT_FILE)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CD) $(BUILD_DIR) && $(QMAKE) $(PROJECT_DIR) || :; $(CD) $(PROJECT_DIR)

qmake: $(MAKEFILE)
	$(MAKE) -C $(BUILD_DIR) -f $(notdir $(MAKEFILE)) $@

test: $(TARGET)
	@./$<

ctags:
	$(CTAGS) $(CTAGSFLAGS) . $(BUILD_DIR)

install: $(INSTALLED_TARGET)
$(INSTALLED_TARGET): $(TARGET)
	@[ ! -d $(@D) ] && $(MKDIR) $(@D) || :
	$(CP) $< $@

uninstall:
	$(RM) $(INSTALLED_TARGET)

clean:
	$(MAKE) -C $(BUILD_DIR) -f $(notdir $(MAKEFILE)) $@

mocclean:
	$(MAKE) -C $(BUILD_DIR) -f $(notdir $(MAKEFILE)) $@

distclean:
	$(MAKE) -C $(BUILD_DIR) -f $(notdir $(MAKEFILE)) $@
