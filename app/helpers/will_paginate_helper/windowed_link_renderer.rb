# Only show the next 5 subsequent pages. i.e. <- prev 2,3,4,5,6 next ->
module WillPaginateHelper
  class WindowedLinkRenderer < WillPaginate::ActionView::LinkRenderer

    def prepare(collection, options, template)
      @container_div = options.delete(:container_div)
      super
    end

    protected

    def windowed_page_numbers
      if current_page <=3
        window_from = 1
        window_to = total_pages < 5 ?  total_pages : 5
      elsif current_page >= (total_pages - 2)
        window_from = total_pages - 4
        window_to = total_pages
      else
        window_from = current_page - 2
        window_to = current_page + 2
      end

      window_from = 1 if window_from < 1
      window_to = total_pages if window_to > total_pages

      (window_from..window_to).to_a
    end

    def link(text, target, attributes = {})
      if target.is_a? Integer
        attributes[:rel] = rel_value(target)
        target = url(target)
      end

      @template.link_to(target, attributes.merge(remote: true)) do
        text.to_s.html_safe
      end
    end
  end
end