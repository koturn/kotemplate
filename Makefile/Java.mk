JAVAC        := javac
JAR          := jar
JAVADOC      := javadoc
ECHO         := echo
MKDIR        := mkdir

SRC_DIR      := src
BIN_DIR      := bin
JAVADOC_DIR  := javadoc
RESOURCE_DIR := resource
MAIN         := <+CURSOR+>
TARGET       := $(MAIN).jar
JD_INDEX     := $(JAVADOC_DIR)/index.html
MAIN_SRC     := $(SRC_DIR)/$(TARGET:.jar=.java)
MAIN_BIN     := $(BIN_DIR)/$(TARGET:.jar=.class)
MANIFEST     := MANIFEST.MF
SRCS         := $(MAIN_SRC)
OBJS         := $(MAIN_BIN)

SRC_CHARSET  := utf-8
DST_CHARSET  := utf-8
JAVAFLAGS    := -sourcepath $(SRC_DIR) -encoding $(SRC_CHARSET) -d $(BIN_DIR) \
                $(if $(SRC_VERSION),-source $(SRC_VERSION),) \
                $(if $(BIN_VERSION),-target $(BIN_VERSION),)
JARFLAGS     := cvfm
JAVADOCFLAGS := -sourcepath $(SRC_DIR) -encoding $(SRC_CHARSET) -d $(JAVADOC_DIR) \
                -charset $(DST_CHARSET) -docencoding $(DST_CHARSET) -private


.PHONY: all javadoc clean cleanobj
all: $(TARGET)

$(TARGET): $(OBJS) $(MANIFEST)
	$(JAR) $(JARFLAGS) $@ $(MANIFEST) -C $(dir $<) . $(RESOURCE_DIR)

$(MANIFEST):
	$(ECHO) "Main-Class: $(MAIN)" > $(MANIFEST)

$(OBJS): $(SRCS)
	@if [ ! -d $(@D) ]; then \
		$(MKDIR) $(@D); \
	fi
	$(JAVAC) $(JAVAFLAGS) $(MAIN_SRC)


javadoc: $(JD_INDEX)

$(JD_INDEX): $(SRC_DIR)/*.java
	$(JAVADOC) $(JAVADOCFLAGS) $^


clean:
	$(RM) $(TARGET) $(BIN_DIR)/*.class $(JAVADOC_DIR)/*

objclean:
	$(RM) $(BIN_DIR)/*.class $(JAVADOC_DIR)/*
