TEX       := platex
DVIPDF    := dvipdfmx
DVIPS     := dvips
PDFVIEWER := acroread
PSVIEWER  := gv
DVIVIEWER := dviout
GNUPLOT   := gnuplot
RM        := rm -f

TEXFLAGS  := -kanji=utf8 -src-specials -interaction=nonstopmode
<+CURSOR+>
TARGET    := report.pdf
PSFILE    := $(TARGET:.pdf=.ps)
DVIFILE   := $(TARGET:.pdf=.dvi)
TEXFILE   := $(TARGET:.pdf=.tex)
AUXFILE   := $(TARGET:.pdf=.aux)
LOGFILE   := $(TARGET:.pdf=.log)

TRUSHLIST := $(AUXFILE) $(DVIFILE) $(LOGFILE) $(PSFILE) $(TARGET)


.SUFFIXES: .dvi .eps .pdf .plt .ps .tex
.dvi.pdf:
	$(DVIPDF) $*
.dvi.ps:
	$(DVIPS) $*
.tex.dvi:
	$(TEX) $(TEXFLAGS) $*
.tex.aux:
	$(TEX) $(TEXFLAGS) $*
.plt.eps:
	$(GNUPLOT) $^
.plt.tex:
	$(GNUPLOT) $^


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
	$(PSVIEWER) $< &

.PHONY: viewdvi
viewdvi: $(DVIFILE)
	$(DVIVIEWER) $< &

.PHONY: clean
clean:
	$(RM) $(TRUSHLIST) *.pbm
