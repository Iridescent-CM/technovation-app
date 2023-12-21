module DatagridHelpers
  def within_results_page_with(selector, &block)
    while has_no_selector?(selector)
      find(".next_page").click
    end

    within(selector) do
      block.call
    end
  end
end
