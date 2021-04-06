# frozen_string_literal: true

module Nashdown
  module Renderer
    class HTML
      def initialize(chart, options = {})
        @chart = chart
        @options = options
      end

      def output
        render_template
      end

      private

      def template
        template_path = File.join(File.dirname(__FILE__), 'templates/chart.html.erb')

        @template ||= File.read(template_path)
      end

      def render_template
        ERB.new(template).result(binding)
      end
    end
  end
end
