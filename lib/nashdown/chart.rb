# frozen_string_literal: true

module Nashdown
  class Chart
    def initialize(markup)
      @markup = markup
    end

    def lines
      ast
    end

    def grid
      lines.map do |line|
        line[:bars].flatten.compact
      end
    end

    def bars
      lines.map { |l| l[:bars] }.flatten.compact
    end

    def chords
      bars.map { |b| b[:chords] }.flatten.compact
    end

    def chord_names
      chords.map(&:inspect)
    end

    private

    def ast
      @ast ||= Transform.new.apply Parser.new.parse @markup
    end
  end
end
