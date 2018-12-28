module Nashdown::AST
  class Chord
    attr_accessor :degree

    def initialize(attributes)
      @attributes = attributes
      assert_valid!
    end

    def degree
      @degree ||= @attributes[:degree].to_i
    end

    private

    def assert_valid!
      raise ArgumentError, 'degree must be within 1-7' unless @attributes[:degree]&.to_i&.between?(1,7)
    end
  end
end