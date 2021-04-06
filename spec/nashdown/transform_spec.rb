require 'spec_helper'

describe Nashdown::Transform do
  include Nashdown::AST

  let(:transform) { described_class.new }

  describe 'End-to-end parsing' do
    let(:nd) do
      <<~ND
        1/3 2-

        3_4-_5/2 5'''
        3'''_2
      ND
    end

    let(:tree) { Nashdown::Parser.new.parse(nd) }
    let(:lines) { transform.apply(tree) }

    def chord(line_index, bar_index, chord_index = 0)
      lines[line_index][:bars][bar_index][:chords][chord_index]
    end

    it 'transforms Chords appropriately' do
      expect(chord(0, 0)).to     eq Nashdown::AST::Chord.new(degree: '1', slash: '3')
      expect(chord(0, 1)).to     eq Nashdown::AST::Chord.new(degree: '2', quality: :minor)
      expect(chord(1, 0, 0)).to   eq Nashdown::AST::Chord.new(degree: '3')
      expect(chord(1, 0, 1)).to   eq Nashdown::AST::Chord.new(degree: '4', quality: :minor)
      expect(chord(1, 0, 2)).to   eq Nashdown::AST::Chord.new(degree: '5', slash: '2')
      expect(chord(1, 1)).to eq Nashdown::AST::Chord.new(degree: '5', ticks: 3)
      expect(chord(2, 0, 0)).to   eq Nashdown::AST::Chord.new(degree: '3', ticks: 3)
      expect(chord(2, 0, 1)).to   eq Nashdown::AST::Chord.new(degree: '2')
    end
  end

  describe 'Ticks' do
    it 'counts ticks' do
      expect(transform.apply({ ticks: "'''" })).to eq ticks: 3
      expect(transform.apply({ ticks: "'" })).to eq ticks: 1
    end
  end

  describe 'Chord qualities' do
    it 'normalizes minor quality' do
      expect(transform.apply({ quality: '-' })).to eq quality: :minor
    end

    it 'normalizes augmented qualities' do
      expect(transform.apply({ quality: 'aug' })).to eq quality: :augmented
      expect(transform.apply({ quality: '+' })).to eq quality:   :augmented
    end

    it 'normalizes diminished qualities' do
      expect(transform.apply({ quality: 'O' })).to eq quality:   :diminished
      expect(transform.apply({ quality: 'o' })).to eq quality:   :diminished
      expect(transform.apply({ quality: 'dim' })).to eq quality: :diminished
    end

    it 'normalizes half-diminished qualities' do
      expect(transform.apply({ quality: '0' })).to eq quality:   :half_diminished
    end
  end

  describe 'Chords' do
    it 'creates Chords for lists of Chords' do
      expect(transform.apply(chords: [{ degree: '1' }]))
        .to eq chords: [Nashdown::AST::Chord.new(degree: '1')]
    end
  end
end
