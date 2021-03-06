ActiveAdmin.register ComponentCategory do
  menu :parent => "menu_system_setting"
  actions :all, :except => :show
  config.sort_order = "id_asc"
  config.batch_actions = false
  config.clear_sidebar_sections!  

  scope :depth0, :default => true
  scope :depth1
  scope :depth2
  scope :depth3

  member_action :edit_group do
    @component_category = ComponentCategory.find(params[:id])
  end

  member_action :set_group, :method => :put do
    @component_category = ComponentCategory.find(params[:id])
    # disable preference if group_id is blank
    params[:component_category][:part_numbers_attributes].each do |key, value|
      value[:preference]="" if value[:group_id].blank?
    end
    update! do |success, failure|
      success.html {redirect_to admin_part_numbers_url}
      failure.html do 
        if @component_category.errors.any?
          flash.now[:error] ||= []
          flash.now[:error].concat(@component_category.errors[:"part_numbers.preference"]).map! {|msg| "<li>#{msg}</li>".html_safe}
        end
        render 'edit_group'
      end
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
  	#render :partial => "form"
    if f.object.new_record?
      render :partial => "new_form"
    else
      f.inputs :component_category_sel_category_type, :disabled => true do
        f.input :ancestry_depth, :as => :select, :collection => [[I18n.t("label.component_category.level#{f.object.ancestry_depth}"), f.object.ancestry_depth]]
        f.input :level0, :input_html=>{:value => ComponentCategory.find(f.object.level0).name} unless f.object.depth==0
        f.input :level1, :input_html=>{:value => ComponentCategory.find(f.object.level1).name} unless f.object.level1.nil?
        f.input :level2, :input_html=>{:value => ComponentCategory.find(f.object.level2).name} unless f.object.level2.nil?
      end

      f.inputs :component_category_list_category_details do    
        f.input :name
        f.input :code, :as => :string   
        f.input :comment
        f.input :updated_by_email, :wrapper_html => { :style => "display:none;" },
                :input_html => {:value => f.object.updated_by_email || current_admin_user.email}
      end

      f.actions 
    end    
  end

  # customize filter panel
  sidebar :filters, :only => :index do
    render :partial => 'search'
  end
  
  controller do
    before_filter :pre_action_proc

  	def pre_action_proc
  	  case params[:action]
  	    when 'new'
  	      #@component_category = ComponentCategory.new(:updated_by_email => current_admin_user.email)
  	    when 'update'
  	      #params[:component_category].merge!(:updated_by_email => current_admin_user.email)
        when 'index'
          if params[:q]
            if params[:q][:level2_eq]
              @cc = ComponentCategory.find(params[:q][:level2_eq])
              params[:q].delete(:level2_eq)
            elsif params[:q][:level1_eq]
              @cc = ComponentCategory.find(params[:q][:level1_eq])
              params[:q].delete(:level1_eq)          
            elsif params[:q][:level0_eq]
              @cc = ComponentCategory.find(params[:q][:level0_eq])
              params[:q].delete(:level0_eq)          
            end
              
            unless @cc.nil?
              @ids = @cc.path_ids
              @ids.each_with_index {|id, i|
                  params[:q].merge!(:"level#{i}_eq" => id)
              }
            end 
          end          
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

  #config.clear_action_items!

  #action_item :except => [:new, :show, :edit_group] do
  #  if controller.action_methods.include?('new') && authorized?(ActiveAdmin::Auth::CREATE, active_admin_config.resource_class)
  #    link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_label), new_resource_path)
  #  end
  #end


  #ajax related collections
  #collection_action :category_select do
  # @category_type = params[:category_type]
  # @component_category = ComponentCategory.new(:ancestry_depth => @category_type,:updated_by_email => current_admin_user.email)
  #  render :partial => "form"
  #end

  # customize filter panel
  #sidebar :filters, :only => :index do
  #   @collection_ary = Array.new(3,[])
  #   @collection_ary[0] = ComponentCategory.depth0.map{|r| [r.name, r.id]}
  #   @level_val_ary = Array.new(3,"")

  #   if params[:q]
  #      if params[:q][:level2_eq]
  #        @cc = ComponentCategory.find(params[:q][:level2_eq])
  #        params[:q].delete(:level2_eq)
  #      elsif params[:q][:level1_eq]
  #        @cc = ComponentCategory.find(params[:q][:level1_eq])
  #        params[:q].delete(:level1_eq)          
  #      elsif params[:q][:level0_eq]
  #        @cc = ComponentCategory.find(params[:q][:level0_eq])
  #        params[:q].delete(:level0_eq)          
  #      end
  #      unless @cc.nil?
  #        @ids = @cc.path_ids
  #        @ids.each_with_index {|id, i|
  #          @collection_ary[i+1] = ComponentCategory.find(id).children.map{|r| [r.name, r.id]} unless i==2
  #          @level_val_ary[i] = id
  #          params[:q].merge!(:"level#{i}_eq" => id)
  #        }
  #      end 
  # end
  #  logger.info "parameter ==================="
  #  logger.info params[:q]
  #   render :partial => 'search', :locals => {:collection_ary => @collection_ary, :level_val_ary => @level_val_ary}
  #end
