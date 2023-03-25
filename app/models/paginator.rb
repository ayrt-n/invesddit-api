module Paginator
  # Default paginates per page of 25
  @paginates_per_page = 25

  # Allow class to set its own default paginates per page if desired
  def paginates_per_page(num)
    @paginates_per_page = num
  end

  # Return active record relation with offset and limit set based on values provided
  def page(page_number, per_page = @paginates_per_page)
    # Set defaults if no values provided (e.g., nils)
    page_number ||= 1
    per_page ||= @paginates_per_page

    offset((page_number - 1) * per_page).limit(per_page)
  end
end
