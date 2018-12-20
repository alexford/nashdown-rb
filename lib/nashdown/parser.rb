
require 'parslet'

class Nashdown::Parser < Parslet::Parser
  rule(:line)    { newlines.maybe >> bars.as(:bars) >> newlines }

  rule(:bars)    { bar.repeat(1) }
  rule(:bar)     { (chord >> opt_tie).repeat(1).as(:chords) >> space }

  rule(:chord) do
    degree.as(:degree) >>
    opt_quality >>
    opt_slash >>
    opt_ticks
  end

  # Chord Components
  rule(:degree)       { (str('b') | str('#')).maybe >> match['1-7'] }
  rule(:opt_slash)    { (str("/") >> match['1-7'].as(:slash)).maybe }
  rule(:opt_quality)  { match('-').as(:quality).maybe }
  rule(:opt_ticks)    { match('\'').repeat(1).as(:ticks).maybe }
  rule(:opt_tie)      { match('_').maybe }

  # Whitespace
  rule(:space?)  { space.maybe }
  rule(:space)   { match[' '].repeat }
  rule(:newlines) { match['\n'].repeat }

  # Root
  rule(:lines)   { line.repeat }
  root(:lines)
end