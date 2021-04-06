require 'spec_helper'

describe Nashdown::Chart do
  let(:nd) do
    <<~ND
      1/3 2-

      3_4- 5'''
    ND
  end

  let(:chart) { described_class.new(nd) }

  describe '#lines' do
    subject { chart.lines }

    it 'returns an array of lines' do
      expect(subject.length).to eq 2
    end
  end

  describe '#chords' do
    subject { chart.chords }

    it 'returns an array of Nashdown::AST::Chords' do
      expect(subject).to all be_an Nashdown::AST::Chord
      expect(subject.length).to be 5
      expect(subject.first).to eq Nashdown::AST::Chord.new(degree: '1', slash: '3')
    end
  end

  describe '#chord_names' do
    subject { chart.chord_names }

    let(:names) do
      [
        '1',
        '2 Minor',
        '3',
        '4 Minor',
        '5'
      ]
    end

    it 'returns an array of chord names' do
      expect(subject).to eq names
    end
  end
end
