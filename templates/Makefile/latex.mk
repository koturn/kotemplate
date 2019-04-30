TEX       := platex
DVIPDF    := dvipdfmx
DVIPS     := dvips
PDFVIEWER := acroread
PSVIEWER  := gv
DVIVIEWER := dviout
GNUPLOT   := gnuplot
RM        := rm -f

TEXFLAGS  := -kanji=utf8 -src-specials -interaction=nonstopmode

TARGET    := <+CURSOR+>.pdf
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


.PHONY: all pdf ps viewpdf viewps viewdvi clean
all: $(DVIFILE)

pdf: $(TARGET)

ps: $(PSFILE)


$(TARGET): $(DVIFILE)

$(DVIFILE): $(TEXFILE) $(AUXFILE)

$(AUXFILE): $(TEXFILE)


viewpdf: $(TARGET)
	$(PDFVIEWER) $< &

viewps: $(PSFILE)
	$(PSVIEWER) $< &

viewdvi: $(DVIFILE)
	$(DVIVIEWER) $< &

clean:
	$(RM) $(TRUSHLIST) *.pbm
