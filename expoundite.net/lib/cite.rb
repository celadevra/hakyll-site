module Nanoc::Filters
  class Cite < Nanoc::Filter
    require "citeproc"
    require "citeproc-ruby"
    require "csl-styles"

    # setup, specify style and bib files
    def run(content)
      style = @item[:csl] || 'harvard'
      if @item[:bib].nil?
        return content
      else
        bib = './bib/' + @item[:bib]
      end

      cp = CiteProc::Processor.new style: style, format: 'html'
      cp.import BibTeX.open(bib).to_citeproc # require bibtex-ruby
      
      keys = content.scan(%r{\[@[A-Za-z0-9:-_].*?\]}) {|w| print "<<#{w}>>"} #test
      content += keys
    end
  end
end
