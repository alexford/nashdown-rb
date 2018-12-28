require 'spec_helper'

describe Nashdown::AST::Chord do
  let(:attributes) { {} }
  let(:chord) { described_class.new(attributes) }

  describe '#initialize' do
    subject { chord }

    context 'without a degree' do
      it 'raises an argument error' do
        expect{ subject }.to raise_error ArgumentError, 'degree must be within 1-7'
      end
    end

    context 'without an invalid degree' do
      let(:attributes) { { degree: '8' } }

      it 'raises an argument error' do
        expect{ subject }.to raise_error ArgumentError, 'degree must be within 1-7'
      end
    end
  end
end