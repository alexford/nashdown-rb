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
              { chords: [{ degree: "1", quality: nil }] },
              { chords: [{ degree: "2", quality: '-' }] }
            ]
          },
          # (Blank line ignored)
          {
            bars: [
              { chords: [{ degree: "3", quality: nil }, { degree: "4", quality: '-' }] },
              { chords: [{ degree: "5", quality: nil }] }
            ]
          }
        ])
      end
    end
  end

  describe "#bars Rule" do
    subject { parser.bars }
    it "parses multiple bars" do
      expect(subject).to parse("1 2_3- 4").as([
        {
          chords: [ { degree: '1', quality: nil } ]
        },
        {
          # Tied bar
          chords: [
            { degree: '2', quality: nil },
            { degree: '3', quality: '-' }
          ]
        },
        {
          chords: [
            { degree: '4', quality: nil }
          ]
        }
      ])
    end

    it "parses one bar" do
      expect(subject).to parse("1").as([
        { chords: [ { degree: '1', quality: nil } ] }
      ])
    end
  end

  describe "#bar Rule" do
    subject { parser.bar }

    it "parses a bar of one Chord" do
      expect(subject).to parse("1").as({
        chords: [ { degree: '1', quality: nil } ]
      })
    end

    it "parses a bar of two Chords tied together" do
      expect(subject).to parse("1_2").as({
        chords: [
          { degree: '1', quality: nil },
          { degree: '2', quality: nil }
        ]
      })
    end

    it "parses a bar of three Chords tied together" do
      expect(subject).to parse("1_2_3").as({
        chords: [
          { degree: '1', quality: nil },
          { degree: '2', quality: nil },
          { degree: '3', quality: nil }
        ]
      })
    end
  end

  describe "#chord Rule" do
    subject { parser.chord }

    it "parses degree and quality" do
      expect(subject).to parse("1").as(degree: '1', quality: nil)
      expect(subject).to parse("5-").as(degree: '5', quality: '-')
    end

    it "does not match degrees outside fo 1-7" do
      expect(subject).not_to parse("0")
      expect(subject).not_to parse("-1")
      expect(subject).not_to parse("-8")
    end
  end
end