require 'parslet'

class Nashdown::Transform < Parslet::Transform
  include Nashdown::AST

  ## Instantiate Chords
  rule(chords: subtree(:chord_attrs)) do |dictionary|
    {
      chords: dictionary[:chord_attrs].map { |attrs| Chord.new(transform_chord_attributes(attrs)) }
    }
  end

  # This is a hack to let key: value rules like the tick counting
  # match on individual keys in the given Hash
  def self.transform_chord_attributes(attrs)
    attrs.map do |k, v|
      [k, new.apply(Hash[k, v]).values.first]
    end.to_h
  end

  ## Chord Attribute Rules

  # Normalize quality symbols
  {
    minor: %w[-],
    augmented: %w[aug +],
    diminished: %w[° O o dim],
    half_diminished: %w[0]
  }.each do |quality, symbols|
    symbols.each do |symbol|
      rule(symbol) { quality }
    end
  end

  # Count ticks
  rule(ticks: simple(:string)) { { ticks: string.length } }

  # Stringify degree
  rule(degree: simple(:slice)) { { degree: slice.to_s } }
end
