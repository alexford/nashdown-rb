class Nashdown::Renderer::HTML
  def initialize(chart, options = {})
    @chart = chart
    @options = options
  end

  def output
    chart = @chart
    render_template
  end

  private

  def template
    template_path = File.join(File.dirname(__FILE__), "templates/chart.html.erb")

    @template ||= File.read(template_path)
  end

  def render_template
    ERB.new(template).result(binding)
  end
end
