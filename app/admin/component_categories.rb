ActiveAdmin.register ComponentCategory do
  menu :parent => I18n.t('system_setting') 
  actions :all, :except => :show
  config.sort_order = "id_asc"
  config.batch_actions = false
  config.clear_sidebar_sections!  

  scope :depth0, :default => true
  scope :depth1
  scope :depth2
  scope :depth3

  #ajax related collections
  collection_action :category_select do
	@category_type = params[:category_type]
	@component_category = ComponentCategory.new(:ancestry_depth => @category_type,:updated_by_email => current_admin_user.email)
	render :partial => "form", :object => @component_category
  end

  collection_action :level1_collection do
	unless params[:level0].empty? 
      @level1 = ComponentCategory.find(params[:level0]).children
	  render :json => @level1.map{|c| [c.id, c.name]}
	else
	  render :json => [["", I18n.t('form.category_sel_tip_option')]] 
	end
  end  

  collection_action :level2_collection do
	unless params[:level1].empty? 
      @level2 = ComponentCategory.find(params[:level1]).children
  	  render :json => @level2.map{|c| [c.id, c.name]}
  	else
	  render :json => [["", I18n.t('form.category_sel_tip_option')]] 
  	end
  end

  index do
	column :name do |c|
	  if c.end_node?
		c.name
	  else
		#@sql_search_hash = Hash.new
		#c.path_ids.each_with_index {|item, index|
		#  @sql_search_hash[:"level#{index}_eq"] = item
		#}
		link_to c.name, admin_component_categories_url(:q => {"level#{c.depth}_eq" => c.id}, :scope => "depth#{c.depth+1}")
	  end
	end
	column :ancestry do |c|
	  c.ancestor_display
	end unless params[:scope].blank? || params[:scope] == 'depth0'
	column :code
	column :comment	
	column :updated_by_email
	default_actions  	
  end

  form do |f|
  	render :partial => "form"
  end

  # customize filter panel
  sidebar :filters, :only => :index do
 	@collection_ary = Array.new(3,[[I18n.t('active_admin.any'),""]])
 	@collection_ary[0] += ComponentCategory.depth0.map{|r| [r.name, r.id]}
 	@level_val_ary = Array.new(3,"")

 	if params[:q]
      @self_categoroy = ComponentCategory.find(params[:q][:level0_eq]) unless params[:q][:level0_eq].nil?
 	  @self_categoroy = ComponentCategory.find(params[:q][:level1_eq]) unless params[:q][:level1_eq].nil?	
   	  @self_categoroy = ComponentCategory.find(params[:q][:level2_eq]) unless params[:q][:level2_eq].nil?
 	  unless @self_categoroy.nil?
 	    @ids = @self_categoroy.path_ids
 		@ids.each_with_index {|id, i|
 		  @level_val_ary[i] = id unless id.nil?
 		}
 		@collection_ary[1] += ComponentCategory.find(@ids[0]).children.map{|r| [r.name, r.id]}
 		@collection_ary[2] += ComponentCategory.find(@ids[1]).children.map{|r| [r.name, r.id]} unless @ids[1].nil?
 	  end
	end
 	render :partial => 'search', :locals => {:collection_ary => @collection_ary, :level_val_ary => @level_val_ary}
  end
  
  controller do
    before_filter :pre_action_proc

  	def pre_action_proc
	  case params[:action]
	    when 'new'
	      @component_category = ComponentCategory.new(:updated_by_email => current_admin_user.email)
	    when 'update'
	      params[:component_category].merge!(:updated_by_email => current_admin_user.email)        
	    end   		
  	end 

	def destroy
	  @component_category = ComponentCategory.find(params[:id])
      unless @component_category.nil?
        destroy!	    		
	    if @component_category.errors[:base].any?
	      flash[:error] ||= []
	      flash[:error].concat(@component_category.errors[:base]).map! {|msg| "<li>#{msg}</li>".html_safe}
	    end	    		
      end
    end  	
  end
end
