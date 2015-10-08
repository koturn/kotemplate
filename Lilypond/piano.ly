\version "2.18.2"

\header {
  title = "Title"
  subtitle = "Subtitle"
  composer = "Composed by: <+AUTHOR+>"
  arranger = "Arranged by：<+AUTHOR+>"
  copyright = "<+AUTHOR+>"
  tagline = ""
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


rightTrack = \relative c' {
  \global
  <e g c,>4 <d f a c,> <e g c,> <d e g b,> |
  <c e g c>1^\fermata \bar "|."
}


leftTrack = \relative c {
  \global
  c4 f g g, |
  c1^\fermata \bar "|."
}


\score {
  \new StaffGroup <<
    \new Staff {
      \clef "treble"
      \rightTrack
    }
    \new Staff {
      \clef "bass"
      \leftTrack
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
  \new StaffGroup <<
    \new Staff {
      \clef "treble"
      \rightTrack
    }
    \new Staff {
      \clef "bass"
      \leftTrack
    }
  >>
  \midi {}
}
