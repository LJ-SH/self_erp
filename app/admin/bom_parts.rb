ActiveAdmin.register BomPart do
  config.batch_actions = false	
  #config.clear_sidebar_sections! 
  config.comments = false
  belongs_to :bom

   active_admin_import :validate => false,
                        :col_sep => ',',
                        :back => :index ,
                        :before_import => proc{|importer|  resource.delete_all},
                        :batch_size => 1000,
                        :template => "admin/bom_parts/import"

  action_item :only => :index do
    link_to('ddd',admin_boms_path)
  end 

  index do
  	#column :id
    column :part_number do |bom_part|
      "#{bom_part.part_number.name}"
    end
    column :part_number_code do |bom_part|
      "#{bom_part.part_number.code}"  
    end
  	column :amount
  	column :location
  	column :comments
  	default_actions
  end

  filter :part_number, :as => :select, :collection => proc {Bom.find(params[:bom_id]).bom_parts.map{|part| [part.part_number.name, part.part_number.id]}}
  filter :part_number_code, :as => :string
  filter :location

  sidebar :parent_bom_info, :only => [:index] do
    attributes_table_for bom do
      row :name do "#{bom.name} (#{bom.code})" end
      row :total_number_of_categories
      row :total_number_of_items
      row :version
    end 
  end

  show do |bom_part|
    attributes_table do
      rows :id, :bom_id, :amount, :location, :comments, :created_at, :updated_at
      row :part_number
      unless bom_part.part_number.associated_parts.blank?
        panel t 'label.part_number.associated_parts' do 
          table_for bom_part.part_number.associated_parts, i18n: PartNumber do
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
      end
    end    
  end

  form do |f|
    if f.object.new_record?
      render :partial => 'new_form'
    else
      f.inputs do
        f.input :part_number, :as => :select, :collection => f.object.part_number.similar_parts, :include_blank => false 
        f.input :amount
        f.input :location
        f.input :comments
      end 
    end

    f.actions
  end

  sidebar :part_number_filter, :only => [:new,:create] do
    # if part_number is selected, then we shall configure search panel appropriately by initializing params[:q]
    unless bom_part.part_number.nil?
      @part_number = bom_part.part_number
      params.merge!(:q => {:component_category_level0_eq => @part_number.component_category.level0})
    end
    @search = PartNumber.search(params[:q])
    render :partial => 'search', :locals => {:search => @search}
  end   

  controller do 
    before_filter :pre_action_proc

    def pre_action_proc
      case params[:action]
        when 'create'
        when 'new'
        when 'update'      
      end       
    end    

    def create
      create! do |format|
        unless @bom_part.errors.empty?
          #logger.info @bom_part.errors
          if @bom_part.errors[:part_number_id].any?
            flash.now[:error] ||= []
            flash.now[:error].concat([@bom_part.errors[:part_number_id].join("; ")])
          end
          format.html {redirect_to :action => :new}
        end       
      end
    end

  end  
end

  #collection_action :part_number_sel do
  #  @part_numbers = PartNumber.metasearch(params[:q]).page(params[:page]).per(5)
  #  respond_to do |format|
  #    format.json {render :json => @part_numbers.map{|pn| [pn.id, "#{pn.code} : #{pn.name}"]}}
  #    format.js 
  #  end
  #end


