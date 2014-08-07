# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Blogging

def articles_essay
  @items.select { |item| item[:extension] == 'page' && item.identifier.match(%r{/docs/}).nil? }.each
end

def articles_essay_sorted
  articles_essay.sort_by do |a|
    attribute_to_time(a[:mtime])
  end.reverse
end
