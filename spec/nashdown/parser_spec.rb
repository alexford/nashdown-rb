require 'spec_helper'

require 'parslet/rig/rspec'

describe Nashdown::Parser do
  let(:parser) { described_class.new }
  
  describe 'Multi-line input' do
    subject { parser }

    context 'muliple lines of bars' do
      let(:input) {
        <<~ND
          1 2-

          3_4- 5
        ND
      }

      it "parses into lines with bars" do
        expect(subject).to parse(input).as([
          { 
            bars: [
              { chords: [{ degree: "1", quality: nil, ticks: nil  }] },
              { chords: [{ degree: "2", quality: '-', ticks: nil  }] }
            ]
          },
          # (Blank line ignored)
          {
            bars: [
              { chords: [{ degree: "3", quality: nil, ticks: nil  }, { degree: "4", quality: '-', ticks: nil  }] },
              { chords: [{ degree: "5", quality: nil, ticks: nil  }] }
            ]
          }
        ])
      end
    end
  end

  describe "#bars Rule" do
    subject { parser.bars }
    it "parses multiple bars" do
      expect(subject).to parse("1 2_3-'' 4").as([
        {
          chords: [ { degree: '1', quality: nil, ticks: nil } ]
        },
        {
          # Tied bar
          chords: [
            { degree: '2', quality: nil, ticks: nil },
            { degree: '3', quality: '-', ticks: "''" }
          ]
        },
        {
          chords: [
            { degree: '4', quality: nil, ticks: nil }
          ]
        }
      ])
    end

    it "parses one bar" do
      expect(subject).to parse("1").as([
        { chords: [ { degree: '1', quality: nil, ticks: nil } ] }
      ])
    end
  end

  describe "#bar Rule" do
    subject { parser.bar }

    it "parses a bar of one Chord" do
      expect(subject).to parse("1").as({
        chords: [ { degree: '1', quality: nil, ticks: nil } ]
      })
    end

    it "parses a bar of two Chords tied together" do
      expect(subject).to parse("1''_2").as({
        chords: [
          { degree: '1', quality: nil, ticks: "''" },
          { degree: '2', quality: nil, ticks: nil }
        ]
      })
    end

    it "parses a bar of three Chords tied together" do
      expect(subject).to parse("1_2_3''").as({
        chords: [
          { degree: '1', quality: nil, ticks: nil },
          { degree: '2', quality: nil, ticks: nil },
          { degree: '3', quality: nil, ticks: "''" }
        ]
      })
    end
  end

  describe "#chord Rule" do
    subject { parser.chord }

    it "parses degree, quality, and ticks" do
      expect(subject).to parse("1").as(degree: '1', quality: nil, ticks: nil)
      expect(subject).to parse("1'").as(degree: '1', quality: nil, ticks: "'")
      expect(subject).to parse("5-").as(degree: '5', quality: '-', ticks: nil)
      expect(subject).to parse("5-'''").as(degree: '5', quality: '-', ticks: "'''")
    end

    it "does not match degrees outside fo 1-7" do
      expect(subject).not_to parse("0")
      expect(subject).not_to parse("-1")
      expect(subject).not_to parse("-8-''")
    end

    it "parses accidentals into the degree" do
      expect(subject).to parse("b5").as(degree: 'b5', quality: nil, ticks: nil)
      expect(subject).to parse("#5").as(degree: '#5', quality: nil, ticks: nil)
    end
  end
end