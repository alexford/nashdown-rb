require 'spec_helper'

describe Nashdown::AST::Chord do
  let(:attributes) { {} }
  let(:chord) { described_class.new(attributes) }

  describe '#initialize' do
    subject { chord }

    context 'without a degree' do
      it 'raises an argument error' do
        expect{ subject }.to raise_error ArgumentError, 'degree attribute must be present'
      end
    end

    context 'without an invalid degree' do
      let(:attributes) { { degree: '8' } }

      it 'raises an argument error' do
        expect{ subject }.to raise_error ArgumentError, 'degree must be within 1-7'
      end
    end
  end

  describe "#quality" do
    subject { chord.quality }

    context 'when quality is provided' do
      let(:attributes) { { degree: '4', quality: :augmented } }
      it { is_expected.to eq :augmented }
    end

    context 'when quality is not provided' do
      let(:attributes) { { degree: '4' } }
      it { is_expected.to eq :major }
    end
  end
  
  describe "#inspect" do
    subject { chord.inspect }
    let(:attributes) { { degree: 'b4', quality: :augmented } }
    it "describes the Chord" do
      expect(subject).to eq "b4 Augmented"
    end
  end
end