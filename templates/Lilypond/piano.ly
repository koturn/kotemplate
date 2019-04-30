\version "2.18.2"

\header {
  title = "Title"
  subtitle = "Subtitle"
  composer = "Composed by: <+AUTHOR+>"
  arranger = "Arranged by：<+AUTHOR+>"
  copyright = "<+AUTHOR+>"
  tagline = ##f
}

\paper {
  #(set-paper-size "a4") line-width = 18.0 \cm
  top-margin = 1.5 \cm
  bottom-margin = 2 \cm
}

global = {
  \key c \major
  \time 4/4
  \tempo 4=120
  % \partial 4  % Auftakt
}


rightHand = \relative c' {
  \global
  <e g c,>4 <d f a c,> <e g c,> <d e g b,> |
  <c e g c>1^\fermata \bar "|."
}


leftHand = \relative c {
  \global
  c4 f g g, |
  c1^\fermata \bar "|."
}


\score {
  \new PianoStaff <<
    \set PianoStaff.instrumentName = #"Piano"
    \new Staff {
      \clef "treble"
      \rightHand
    }
    \new Staff {
      \clef "bass"
      \leftHand
    }
  >>
  \layout {
    \context {
      \Staff
      \override StringNumber #'transparent = ##t
    }
  }
}


\score {
  \unfoldRepeats
  \new PianoStaff <<
    \new Staff {
      \clef "treble"
      \rightHand
    }
    \new Staff {
      \clef "bass"
      \leftHand
    }
  >>
  \midi {}
}
