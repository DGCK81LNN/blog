require "rouge"

module Rouge
  module Lexers
    class Uiua < RegexLexer
      title "Uiua"
      tag "uiua"
      filenames "*.ua"

      state :root do
        rule /\s+/, Text::Whitespace
        rule /\|\d+\.\d+/, Keyword::Type
        rule /[(){}\[\]|_.,:◌∘?!^←↚~]/, Punctuation
        rule /\$ /, Str, :raw_string
        rule /\$\$ /, Str, :raw_format_string
        rule /"/, Str, :string
        rule /\$"/, Str, :format_string
        rule /@(\\u\{[0-9A-Za-z]+\}|\\u[0-9A-Za-z]{4}|\\x[0-9A-Za-z]{2}|\\?.)/, Str::Char
        rule /¯?\d+(\/\d+|[Ee][+-]?\d+)?/, Num
        rule /¯?([ηπτ∞ieεW]|NaN|MaxInt)\b/, Keyword::Constant
        rule /\b(Days|Months|MonthDays|LeapMonthDays)\b/, Name::Constant
        rule /\b(White|Black|Red|Orange|Yellow|Green|Cyan|Blue|Purple|Magenta)\b/, Name::Constant
        rule /\b(Rainbow|Lesbian|Gay|Bi|Trans|Pan|Ace|Aro|AroAce|Enby|Fluid|Queer|Agender|PrideFlags|PrideFlagNames)\b/, Name::Constant
        rule /\b(True|False|NULL)\b/, Name::Constant
        rule /\b(Logo|Lena|Cats|Music|Lorem)\b/, Name::Constant
        rule /\b(A₁|A₂|A₃|C₂|C₃|E₃)\b/, Name::Constant
        rule /\b(Os|Family|Arch|ExeExt|DllExt|Sep|ThisFile|ThisFileName|ThisFileDir|WorkingDir|NumProcs)\b/, Name::Constant
        rule /\b(HexDigits|Planets|Zodiac|Suits|Cards|Chess|Moon|Skin|People|Hair)\b/, Name::Constant
        rule /[¬±¯⌵√∿⌊⌈⁅⧻△⇡⊢⊣⇌♭¤⋯⍉⍆⍏⍖⊚⊛◴◰□⋕⚂]/, Name::Builtin
        rule /[=≠<≤>≥+\-×÷◿∨ⁿₙ↧↥∠ℂ≍⊟⊂⊏⊡↯↙↘↻⤸▽⌕⦷∊⊗⨂⊥⍤]/, Operator
        rule /[\/∧\\∵≡⍚⊞⧅⧈⍥⊕⊜◇⋅˜⊙𝄐⟜⊸⤙⤚◠◡𝄈∩⌅°⌝⍩∂∫]/, Keyword
        rule /[⍜⊃⊓⍢⬚⨬⍣]/, Keyword::Declaration
        rule /#.*?(?=\n)/, Comment::Single
        rule /&[a-z]+/, Name::Builtin
        rule /\b[a-zA-Z]+(__\d+)?/, Name
        rule /\S/, Name
      end

      state :raw_string do
        rule /.+/, Str
        rule //, pop!
      end

      state :string do
        rule /\\u\{[0-9A-Za-z]+\}|\\u[0-9A-Za-z]{4}|\\x[0-9A-Za-z]{2}|\\./, Str::Escape
        rule /"/, Str, :pop!
        rule /.[^\\"]*/, Str
      end

      state :raw_format_string do
        rule /_/, Str::Interpol
        mixin /\\_/, Str::Escape
        rule /.[^\\_]*/, Str
        rule //, pop!
      end

      state :format_string do
        rule /_/, Str::Interpol
        rule /"/, Str, :pop!
        rule /.[^\\"_]*/, Str
      end
    end
  end
end
