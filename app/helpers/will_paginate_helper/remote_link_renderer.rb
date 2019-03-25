# Only show the next 5 subsequent pages. i.e. <- prev 2,3,4,5,6 next ->
module WillPaginateHelper
  class RemoteLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def link(text, target, attributes = {})
      attributes['data-remote'] = true
      super
    end
  end
end