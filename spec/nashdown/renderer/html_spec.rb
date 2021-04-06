# frozen_string_literal: true

require 'spec_helper'

describe Nashdown::Renderer::HTML do
  let(:nd) do
    <<~ND
      1/3 2-

      3_4- 5\'\'\'
    ND
  end

  # NOTE: This comment is to reset broken highlighting :\

  let(:chart) { Nashdown::Chart.new(nd) }
  let(:options) { {} }
  let(:renderer) { described_class.new(chart, options) }

  describe '#output' do
    subject(:output) { renderer.output }

    it 'does something' do
      puts output
      expect(output).to include('<html>')
    end
  end
end
