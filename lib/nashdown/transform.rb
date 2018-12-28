require 'parslet'

class Nashdown::Transform < Parslet::Transform
  include Nashdown::AST

  QUALITY_SYMBOLS = {
    minor: %w(-),
    augmented: %w(aug +),
    diminished: %w(° O o dim),
    half_diminished: %w(0)
  }.freeze

  # Normalize quality symbols
  QUALITY_SYMBOLS.each do |quality, symbols|
    symbols.each do |symbol|
      rule(symbol) { quality }
    end
  end
end