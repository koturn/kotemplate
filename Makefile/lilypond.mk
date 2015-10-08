PDFVIEWER := "C:/Program Files (x86)/Adobe/Reader 11.0/Reader/AcroRd32.exe"
GSVIEWER  := "C:/Program Files (x86)/Ghostgum/gsview/gsview32.exe"

LILYPOND  := lilypond
LILYFLAGS :=

BASENAME := piano
PDFFILE  := $(BASENAME).pdf
PSFILE   := $(BASENAME).ps
MIDFILE  := $(BASENAME).mid
TARGETS  := $(PDFFILE) $(MIDFILE)
SRC      := $(BASENAME).ly


%.mid:
	$(LILYPOND) $(LILYFLAGS) $(SRC)
%.pdf:
	$(LILYPOND) --pdf $(SRC)
%.ps:
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
	$(GSVIEWER) $< &


.PHONY: clean
clean:
	$(RM) $(TARGETS) *.log *.ps
