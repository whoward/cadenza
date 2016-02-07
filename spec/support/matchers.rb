require 'nokogiri/diff'

RSpec::Matchers.define :equal_html do |expected|
  match do |actual|
    expected_doc = Nokogiri::HTML(expected)
    actual_doc   = Nokogiri::HTML(actual)

    full_diff = expected_doc.diff(actual_doc)

    # reject any diffs which have no change or are text nodes containing only whitespace
    # finally group each diff by it's XML path
    @diff = full_diff.reject do |change, node|
      change == ' ' || (node.text? && node.to_html =~ /^\s*$/)
    end

    @diff = @diff.group_by { |_change, node| node.path }

    @diff.empty?
  end

  failure_message do |_actual|
    result = ''

    @diff.each do |path, diffs|
      result << path << "\n"

      diffs.each do |change, node|
        result << change << ' ' << node.to_html.inspect << "\n"
      end

      result << "\n"
    end

    result
  end
end

RSpec::Matchers.define :equal_syntax_tree do |expected|
  match do |actual|
    @tree = FixtureSyntaxTree.new(expected)
    @tree.equals(actual)
  end

  failure_message do |actual|
    "expected that #{actual.inspect} would have an identical syntax tree to #{@tree.document.inspect}"
  end
end
