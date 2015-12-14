LILYPOND  := lilypond
LILYFLAGS :=

PDFVIEWER := acroread
PSVIEWER  := gv

BASENAME := piano
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


.PHONY: all
all: $(TARGETS)

.PHONY: pdf
pdf: $(PDFFILE)

.PHONY: ps
ps: $(PSFILE)


$(TARGETS): $(SRC)

$(PDFFILE): $(SRC)

$(PSFILE): $(SRC)

$(MIDFILE): $(SRC)


.PHONY: viewpdf
viewpdf: $(PDFFILE)
	$(PDFVIEWER) $< &

.PHONY: viewps
viewps: $(PSFILE)
	$(PSVIEWER) $< &


.PHONY: clean
clean:
	$(RM) $(TARGETS) *.log *.ps
