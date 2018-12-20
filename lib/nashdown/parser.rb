
require 'parslet'

class Nashdown::Parser < Parslet::Parser
  root(:lines)
  rule(:lines) { line.repeat }

  rule(:line) { chords.as(:chords) >> match('\n') }

  rule(:chords)  { chord.repeat }
  rule(:chord)   { degree.as(:degree) >> opt_quality.as(:quality) >> space? }

  private

  rule(:degree)       { match['1-7'] }
  rule(:opt_quality) { match('-').maybe }

  rule(:integer) { c('0-9', :int) }
  rule(:space?)  { space.maybe }
  rule(:space)   { match[' '].repeat }

  rule(:newlines) { match['\n'].repeat }

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