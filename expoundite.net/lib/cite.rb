module Nanoc::Filters
  class Cite < Nanoc::Filter
    identifier :cite
    require "citeproc"
    # require "citeproc-ruby"
    require "csl/styles"

    # setup, specify style and bib files
    def run(content, params={})
      style = @item[:csl] || 'harvard'
      if @item[:bib].nil?
        return content
      else
        bib = 'content/bib/' + @item[:bib]
      end

      cp = CiteProc::Processor.new style: style, format: 'html'
      cp.import BibTeX.open(bib).to_citeproc # require bibtex-ruby
      
      keys_p = content.scan(%r{\[@[A-Za-z0-9:-_].*?\]}).map {|key| key.gsub(/[@\[\]]/, '')}
      keys_t = content.scan(%r{\b@[A-Za-z0-9:-_].*?}).map {|key| key.gsub(/@/, '')}
      keys = (keys_p + keys_t).uniq
      #content += (cp.render :bibliography, id: keys[0]).to_s
      content += cp.bibliography { keys }.to_s
      content
    end
  end
end
