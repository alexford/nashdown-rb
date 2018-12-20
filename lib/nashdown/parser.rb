
require 'parslet'

class Nashdown::Parser < Parslet::Parser
  rule(:line)    { newlines.maybe >> bars.as(:bars) >> newlines }

  rule(:bars)    { bar.repeat(1) }
  rule(:bar)     { (chord >> opt_tie).repeat(1).as(:chords) >> space }

  rule(:chord) do
    degree.as(:degree) >>
    opt_quality.as(:quality) >>
    opt_ticks.as(:ticks)
  end

  # Chord Components
  rule(:degree)       { (str('b') | str('#')).maybe >> match['1-7'] }
  rule(:opt_quality)  { match('-').maybe }
  rule(:opt_tie)      { match('_').maybe }
  rule(:opt_ticks)    { match('\'').repeat(1).maybe }

  # Whitespace
  rule(:space?)  { space.maybe }
  rule(:space)   { match[' '].repeat }
  rule(:newlines) { match['\n'].repeat }

  # Root
  rule(:lines)   { line.repeat }
  root(:lines)
end