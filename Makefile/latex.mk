TEX       ?= platex
DVIPDF    ?= dvipdfmx
DVIPS     ?= dvips
PDFVIEWER ?= acroread
GSVIEWER  ?= gv
DVIVIEWER ?= dviout
RM        ?= rm -f

TEXFLAGS  ?= -src-specials -interaction=nonstopmode

TARGET    := report.pdf
PSFILE    := $(TARGET:%.pdf=%.ps)
DVIFILE   := $(TARGET:%.pdf=%.dvi)
TEXFILE   := $(TARGET:%.pdf=%.tex)

AUXFILE   := $(TARGET:%.pdf=%.aux)
LOGFILE   := $(TARGET:%.pdf=%.log)

TRUSHLIST := $(AUXFILE) $(DVIFILE) $(LOGFILE) $(PSFILE) $(TARGET)


.SUFFIXES: .dvi .tex .pdf .ps
.dvi.pdf:
	$(DVIPDF) $*
.dvi.ps:
	$(DVIPS) $*
.tex.dvi:
	$(TEX) $(TEXFLAGS) $*
.tex.aux:
	$(TEX) $(TEXFLAGS) $*


.PHONY: all
all: $(DVIFILE)

.PHONY: pdf
pdf: $(TARGET)

.PHONY: ps
ps: $(PSFILE)


$(TARGET): $(DVIFILE)

$(DVIFILE): $(TEXFILE) $(AUXFILE)

$(AUXFILE): $(TEXFILE)


.PHONY: viewpdf
viewpdf: $(TARGET)
	$(PDFVIEWER) $< &

.PHONY: viewps
viewps: $(PSFILE)
	$(GSVIEWER) $< &

.PHONY: viewdvi
viewdvi: $(DVIFILE)
	$(DVIVIEWER) $< &

.PHONY: clean
clean:
	$(RM) $(TRUSHLIST) *.pbm
