require 'spec_helper'

require 'parslet/rig/rspec'

describe Nashdown::Parser do
  let(:parser) { described_class.new }
  
  describe 'Multi-line input' do
    let(:input) do
      <<~ND
        1 2-
        2
        3
      ND
    end

    subject { parser }

    context 'muliple lines of chords' do  
      it "parses into lines with chords" do
        expect(subject).to parse(input).as([
          { chords: [ { degree: "1", quality: nil }, { degree: "2", quality: '-' } ] },
          { chords: [ { degree: "2", quality: nil } ] },
          { chords: [ { degree: "3", quality: nil } ] }
        ])
      end
    end
  end

  describe "#chords Rule" do
    subject { parser.chords }
    it "parses multiple chords" do
      expect(subject).to parse("1 2 3- 4").as([
        { degree: '1', quality: nil },
        { degree: '2', quality: nil },
        { degree: '3', quality: '-' },
        { degree: '4', quality: nil }
      ])
    end

    it "parses one chord" do
      expect(subject).to parse("1").as([
        { degree: '1', quality: nil }
      ])
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