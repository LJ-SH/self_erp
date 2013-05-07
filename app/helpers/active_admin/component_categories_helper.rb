module ActiveAdmin::ComponentCategoriesHelper	
  def component_category_collection_url_help(depth)
    @depth = depth.nil?? 0 : depth
	admin_component_categories_url(:scope => "depth#{@depth}")
  end	
end