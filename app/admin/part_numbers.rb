ActiveAdmin.register PartNumber do
  menu :parent => 'menu_rnd'
  config.batch_actions = false
  config.clear_sidebar_sections!  

  scope :all, :default => true
  scope :status_in_progress
  scope :status_pending_approval
  scope :status_active
  scope :status_outdated
  scope :status_transient

  index do
    column :code do |part|
      link_to "#{part.code}", admin_part_number_url(part)
    end
    column :component_category_id do |pn|
      pn.associated_component_category
    end
    column :supplier do |pn|
      pn.associated_supplier
    end
    #column :vendor_code    
    if current_admin_user.admin?
      column  :latest_price
    end
    column :group_id
    column :inventories do |pn|
      pn.inventories.blank?? 0:(pn.inventories.sum(:quantity_of_surplus)+pn.inventories.sum(:quantity_of_in_manufacturing))
    end
    #actions :defaults => true do |resource|
    #  link = link_to 'edit_group', edit_group_admin_component_category_path(resource.component_category_id), :class=>"member_link"
    #end   
    actions :defaults => false do |resource|
      link = link_to I18n.t('active_admin.edit_group'), edit_group_admin_component_category_path(resource.component_category_id), :class=>"member_link"
      link += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class=>"member_link edit_link"
      link += link_to I18n.t('active_admin.delete'), resource_path(resource),:method => :delete, :clas=>"member_link delete_link", :confirm => I18n.t('active_admin.delete_confirmation')
      link
    end      
  end

  form do |f|
    render :partial => "form"
  end 


  # here is the part for show action, seperated into 2 column. comment-by-LJ on 2-May-2013
  show do |pn|
    attributes_table do
      rows :name, :code
      row  :status do
        I18n.t("active_admin.scopes.#{pn.status}")
      end
      if current_admin_user.admin?
        row  :latest_price
      end
      rows :group_id, :preference, :description
      row   :appendix do
        unless pn.appendix.blank? then
          link_to "#{pn.appendix_name}", "#{pn.appendix.url}" 
        end
      end       
      rows :prepared_by, :approved_by
      rows :old_code, :vendor_code, :created_at
    end

    panel t 'label.part_number.associated_parts' do 
      table_for pn.associated_parts, i18n: PartNumber do 
        column :code do |part|
          link_to "#{part.code}", admin_part_number_url(part)
        end
        column :supplier
        column :status
        if current_admin_user.admin?
          column  :latest_price
        end        
        column :preference
      end
    end

    panel t 'label.part_number.change_history_info' do 
      table_for pn.change_histories, i18n: ChangeHistory do
        column :notes
        column :updated_by
        column :updated_at
      end
    end
  end

  # complementary sidebar for show method
  sidebar :part_number_complementary_info, :only => [:show] do
    attributes_table_for part_number.component_category do 
      row t "label.part_number.component_category" do
        part_number.associated_component_category
      end 
    end 
    attributes_table_for part_number.supplier do
      row t "label.part_number.supplier" do 
        link_to "#{part_number.associated_supplier}", admin_supplier_url(part_number.supplier_id)
      end
    end    
    button_to t("link.part_number.back_to_index"), {:action => :index}, :method => "get"
  end

  # customize filter panel
  sidebar :filters, :only => :index do
    render :partial => 'search'
  end

  controller do
    before_filter :pre_index_proc, :only => :index

    def pre_index_proc
      if params[:pag]
        @per_page = params[:pag]
      else 
        @per_page = 10
      end
      if params[:q]
        if params[:q][:component_category_level3_eq]
          @cc = ComponentCategory.find(params[:q][:component_category_level3_eq])
        elsif params[:q][:component_category_level2_eq]
          @cc = ComponentCategory.find(params[:q][:component_category_level2_eq])
        elsif params[:q][:component_category_level1_eq]
          @cc = ComponentCategory.find(params[:q][:component_category_level1_eq])
        elsif params[:q][:component_category_level0_eq]
          @cc = ComponentCategory.find(params[:q][:component_category_level0_eq])
        end

        unless @cc.nil?
          @ids = @cc.path_ids
          @ids.each_with_index {|id, i|
            params[:q].merge!(:"component_category_level#{i}_eq" => id)
          }
        end      
      end       
    end

    def create
      @supplier = Supplier.find(params[:part_number][:supplier_id]) unless params[:part_number][:supplier_id].nil?
      @component_category = ComponentCategory.find(params[:part_number][:component_category_id]) unless params[:part_number][:component_category_id].nil?

      @part_number_name = @component_category.full_display+"_"+@supplier.name 
      params[:part_number].merge!({:name => @part_number_name})

      @part_number = PartNumber.new(params[:part_number])
      create! do |format|
      	unless @part_number.errors.empty?
      	  if @part_number.errors[:code].any?
      	    flash.now[:error] ||= []
      		flash.now[:error].concat([@part_number.errors[:code].join("; ")])
          end
          format.html {redirect_to :action => :new}
      	end
      end
    end

    def update
      #@part_number = PartNumber.find(params[:id])
      # the below code is for optional comment, comment_by_LJ on 6-Jun-2013
      #unless params[:part_number][:change_histories_attributes]['0'].nil?
      #  if params[:part_number][:change_histories_attributes]['0'][:notes].blank?
      #	  params[:part_number].delete("change_histories_attributes")
      #  end
      #end
      #@supplier = Supplier.find(params[:part_number][:supplier_id]) unless params[:part_number][:supplier_id].nil?
      #@component_category = ComponentCategory.find(params[:part_number][:component_category_id]) unless params[:part_number][:component_category_id].nil?

      #@part_number_name = @component_category.full_display+"_"+@supplier.name 
      #params[:part_number].merge!({:name => @part_number_name})      
      update! do |format|
      	unless @part_number.errors.empty?
      	  if @part_number.errors[:code].any?
      	    flash.now[:error] ||= []
      		flash.now[:error].concat([@part_number.errors[:code].join("; ")])
          end
      	  format.html {redirect_to :action => :edit}
      	end      	
      end
    end

    def index 
      index! do |format|
        format.html 
        format.js
      end        
    end
  end  
end


  # customize filter panel
  #sidebar :filters, :only => :index do
  #  @collection_ary = Array.new(4,[])
  #  @collection_ary[0] = ComponentCategory.valid_depth0_collection.map{|r| [r.name, r.id]}
  #  @level_val_ary = Array.new(4,"")

  #  if params[:q]
  #    if params[:q][:cc_level3_eq]
  #      @cc = ComponentCategory.find(params[:q][:cc_level3_eq])
  #    elsif params[:q][:cc_level2_eq]
  #      @cc = ComponentCategory.find(params[:q][:cc_level2_eq])
  #    elsif params[:q][:cc_level1_eq]
  #      @cc = ComponentCategory.find(params[:q][:cc_level1_eq])
  #    elsif params[:q][:cc_level0_eq]
  #      @cc = ComponentCategory.find(params[:q][:cc_level0_eq])
  #    end
  #    unless @cc.nil?
  #      @ids = @cc.path_ids
  #      @ids.each_with_index {|id, i|
  #        @collection_ary[i+1] = ComponentCategory.find(id).children.map{|r| [r.name, r.id]} unless i==3
  #        @level_val_ary[i] = id
  #      }
  #    end      
  #  end    

  #  render :partial => 'search', :locals => {:collection_ary => @collection_ary, :level_val_ary => @level_val_ary}
  #end
