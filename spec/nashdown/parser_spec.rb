require 'spec_helper'

require 'parslet/rig/rspec'

describe Nashdown::Parser do
  let(:parser) { described_class.new }

  describe 'Multi-line input' do
    subject { parser }

    context 'muliple lines of bars' do
      let(:input) do
        <<~ND
          1/3 2-

          3_4- 5
        ND
      end

      it 'parses into lines with bars' do
        expect(subject).to parse(input).as([
                                             {
                                               bars: [
                                                 { chords: [{ degree: '1', slash: '3' }] },
                                                 { chords: [{ degree: '2', quality: '-' }] }
                                               ]
                                             },
                                             # (Blank line ignored)
                                             {
                                               bars: [
                                                 { chords: [{ degree: '3' }, { degree: '4', quality: '-' }] },
                                                 { chords: [{ degree: '5' }] }
                                               ]
                                             }
                                           ])
      end
    end
  end

  describe '#bars Rule' do
    subject { parser.bars }
    it 'parses multiple bars' do
      expect(subject).to parse("1 2_3-'' 4").as([
                                                  {
                                                    chords: [{ degree: '1' }]
                                                  },
                                                  {
                                                    # Tied bar
                                                    chords: [
                                                      { degree: '2' },
                                                      { degree: '3', quality: '-', ticks: "''" }
                                                    ]
                                                  },
                                                  {
                                                    chords: [
                                                      { degree: '4' }
                                                    ]
                                                  }
                                                ])
    end

    it 'parses one bar' do
      expect(subject).to parse('1').as([
                                         { chords: [{ degree: '1' }] }
                                       ])
    end
  end

  describe '#bar Rule' do
    subject { parser.bar }

    it 'parses a bar of one Chord' do
      expect(subject).to parse('1').as({
                                         chords: [{ degree: '1' }]
                                       })
    end

    it 'parses a bar of two Chords tied together' do
      expect(subject).to parse("1''_2").as({
                                             chords: [
                                               { degree: '1', ticks: "''" },
                                               { degree: '2' }
                                             ]
                                           })
    end

    it 'parses a bar of three Chords tied together' do
      expect(subject).to parse("1Maj7_2_3''").as({
                                                   chords: [
                                                     { degree: '1', extensions: [degree: '7', prefix: 'Maj'] },
                                                     { degree: '2' },
                                                     { degree: '3', ticks: "''" }
                                                   ]
                                                 })
    end
  end

  describe '#chord Rule' do
    subject { parser.chord }

    it 'parses degree, quality, slash, and ticks' do
      expect(subject).to parse('1').as(degree: '1')
      expect(subject).to parse("1'").as(degree: '1', ticks: "'")
      expect(subject).to parse('5-').as(degree: '5', quality: '-')
      expect(subject).to parse("5-'''").as(degree: '5', quality: '-', ticks: "'''")
    end

    it 'parses augmented qualities' do
      expect(subject.parse('1+')).to include quality: '+'
      expect(subject.parse('1aug')).to include quality: 'aug'
    end

    it 'parses diminished qualities' do
      expect(subject.parse('2°')).to include quality: '°'
      expect(subject.parse('2O')).to include quality: 'O'
      expect(subject.parse('2dim')).to include quality: 'dim'
    end

    it 'parses extensions into the extensions key' do
      expect(subject.parse('2M7')).to include extensions: [
        { degree: '7', prefix: 'M' }
      ]

      expect(subject.parse('2min7add9')).to include extensions: [
        { degree: '7', prefix: 'min' },
        { degree: '9', prefix: 'add' }
      ]

      expect(subject.parse('2min7add13')).to include extensions: [
        { degree: '7', prefix: 'min' },
        { degree: '13', prefix: 'add' }
      ]

      expect(subject.parse('2min7add2add3add4add5add6')).to include extensions: [
        { degree: '7', prefix: 'min' },
        { degree: '2', prefix: 'add' },
        { degree: '3', prefix: 'add' },
        { degree: '4', prefix: 'add' },
        { degree: '5', prefix: 'add' },
        { degree: '6', prefix: 'add' }
      ]

      expect(subject.parse('2M7sus4')).to include extensions: [
        { degree: '7', prefix: 'M' },
        { degree: '4', prefix: 'sus' }
      ]

      expect(subject.parse('2m9')).to include extensions: [
        { degree: '9', prefix: 'm' }
      ]

      expect(subject.parse('2Maj7')).to include extensions: [
        { degree: '7', prefix: 'Maj' }
      ]

      expect(subject.parse('2maj7')).to include extensions: [
        { degree: '7', prefix: 'maj' }
      ]

      expect(subject.parse('2min7')).to include extensions: [
        { degree: '7', prefix: 'min' }
      ]

      expect(subject.parse('2dom7')).to include extensions: [
        { degree: '7', prefix: 'dom' }
      ]
    end

    it 'does not match degrees outside fo 1-7' do
      expect(subject).not_to parse('0')
      expect(subject).not_to parse('-1')
      expect(subject).not_to parse("-8-''")
    end

    it 'parses accidentals into the degree key' do
      expect(subject.parse('b5')).to include degree: 'b5'
      expect(subject.parse('#6')).to include degree: '#6'
    end

    it 'parses slashes into the slash key' do
      expect(subject.parse('1/3')).to include degree: '1', slash: '3'
      expect(subject.parse('1-/3')).to include degree: '1', slash: '3', quality: '-'
    end
  end
end
