
require 'parslet'

class Nashdown::Parser < Parslet::Parser
  root(:lines)
  rule(:lines)   { line.repeat }

  rule(:line)    { bars.as(:bars) >> newlines }

  rule(:bars)    { bar.repeat(1) }
  rule(:bar)     { (chord >> opt_tie).repeat(1).as(:chords) >> space }

  rule(:chord)  do
    degree.as(:degree) >>
    opt_quality.as(:quality) >>
    opt_ticks.as(:ticks)
  end

  rule(:degree)       { match['1-7'] }
  rule(:opt_quality)  { match('-').maybe }
  rule(:opt_tie)      { match('_').maybe }
  rule(:opt_ticks)    { match('\'').repeat(1).maybe }

  rule(:integer) { c('0-9', :int) }
  rule(:space?)  { space.maybe }
  rule(:space)   { match[' '].repeat }

  rule(:newlines) { match['\n'].repeat }

  private

  # Defines a string followed by any number of spaces. 
  def s(str)
    str(str) >> space? 
  end

  # Defines a set of characters followed by any number of spaces.
  def c(chars, name=nil)
    if name
      match[chars].as(name) >> space?
    else
      match[chars] >> space?
    end
  end
end