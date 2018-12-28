require 'spec_helper'

describe Nashdown::Transform do
  include Nashdown::AST

  let(:transform) { described_class.new }

  describe "Chord qualities" do
    it "normalizes minor quality" do
      expect(transform.apply({ quality: '-' })).to eq quality: :minor
    end

    it "normalizes augmented qualities" do
      expect(transform.apply({ quality: 'aug' })).to eq quality: :augmented
      expect(transform.apply({ quality: '+' })).to eq quality:   :augmented
    end

    it "normalizes diminished qualities" do
      expect(transform.apply({ quality: 'O' })).to eq quality:   :diminished
      expect(transform.apply({ quality: 'o' })).to eq quality:   :diminished
      expect(transform.apply({ quality: 'dim' })).to eq quality: :diminished
    end

    it "normalizes half-diminished qualities" do
      expect(transform.apply({ quality: '0' })).to eq quality:   :half_diminished
    end
  end
end