
require 'parslet'

class Nashdown::Parser < Parslet::Parser
  rule(:line)    { newlines.maybe >> bars.as(:bars) >> newlines }

  rule(:bars)    { bar.repeat(1) }
  rule(:bar)     { (chord >> opt_tie).repeat(1).as(:chords) >> space }

  rule(:chord) do
    degree.as(:degree) >>
    quality.maybe >>
    extensions.maybe >>
    slash.maybe >>
    ticks.maybe
  end

  # Chord Components
  rule(:degree)   { (str('b') | str('#')).maybe >> match['1-7'] }
  rule(:slash)    { str("/") >> match['1-7'].as(:slash) }
  rule(:quality)  { (str('-') | str('+') | str('aug') | str('O') | str('dim') | str('0') | str('°') ).as(:quality) }
  rule(:ticks)    { match('\'').repeat(1).as(:ticks) }
  rule(:extensions) { extension.repeat(1).as(:extensions) }

    # Chord Helpers
    rule(:extension)  { ext_prefix.as(:prefix) >> (match['2-9'] | str('10') | str('11') | str('12') | str('13')).as(:degree) }
    rule(:ext_prefix) { str('Maj') | str('maj') | str('min') | str('dom') | str('m') | str('M') | str('sus') | str('add') }
    rule(:opt_tie)    { match['_'].maybe }

  # Whitespace
  rule(:space?)   { space.maybe }
  rule(:space)    { match[' '].repeat }
  rule(:newlines) { match['\n'].repeat }

  # Root
  rule(:lines)   { line.repeat }
  root(:lines)
end