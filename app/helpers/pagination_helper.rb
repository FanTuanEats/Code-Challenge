##
# This contains methods to help calculate and represent pagination data.
module PaginationHelper

    def pagination(total_items)
        raise ApiException.new(
            major_code: StatusCodes::BAD_REQUEST
        ), 'Page must be positive' if current_page < 1
        raise ApiException.new(
            major_code: StatusCodes::BAD_REQUEST
        ), 'Count must be positive' if items_per_page < 1

        { 
            page: current_page,
            count: items_per_page,
            total_items: total_items,
            total_pages: total_pages(total_items)
        }
    end
    
    def offset
        (current_page - 1) * items_per_page
    end

    def items_per_page
        pp = (params[:count] || params[:page_size] || params[:items_per_page] || 10).to_i
        # Limit to 50 maximum
        pp > 50 ? 50 : pp
    end
  
    def current_page
        (params[:page] || 1).to_i
    end
  
    def total_pages(total_items)
        (items_per_page == 0 ? 0 : ((total_items.to_f / items_per_page).ceil))
    end
  
  end
  