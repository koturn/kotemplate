LILYPOND  := lilypond
LILYFLAGS :=

PDFVIEWER := acroread
PSVIEWER  := gv

BASENAME := <+CURSOR+>
PDFFILE  := $(BASENAME).pdf
PSFILE   := $(BASENAME).ps
MIDFILE  := $(BASENAME).mid
TARGETS  := $(PDFFILE) $(MIDFILE)
SRC      := $(BASENAME).ly


.SUFFIXES: .ly .mid .pdf .ps
.ly.mid:
	$(LILYPOND) $(LILYFLAGS) $(SRC)
.ly.pdf:
	$(LILYPOND) --pdf $(SRC)
.ly.ps:
	$(LILYPOND) --ps $(SRC)


.PHONY: all pdf ps viewpdf viewps clean
all: $(TARGETS)

pdf: $(PDFFILE)

ps: $(PSFILE)


$(TARGETS): $(SRC)

$(PDFFILE): $(SRC)

$(PSFILE): $(SRC)

$(MIDFILE): $(SRC)


viewpdf: $(PDFFILE)
	$(PDFVIEWER) $< &

viewps: $(PSFILE)
	$(PSVIEWER) $< &

clean:
	$(RM) $(TARGETS) *.log *.ps
