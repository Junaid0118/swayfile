# lib/custom_renderer.rb
class CustomPaginationRenderer < WillPaginate::ActionView::LinkRenderer
    protected
  
    def html_container(html)
      tag(:ul, html, class: "pagination")
    end
  
    def page_number(page)
      tag(:li, class: "page-item" + (page == current_page ? " active" : "")) do
        link(page, page, class: "page-link")
      end
    end
  
    def previous_or_next_page(page, text, classname)
      tag(:li, class: "page-item #{classname}") do
        link(text, page || "#", class: "page-link")
      end
    end
  end
  