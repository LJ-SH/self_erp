ActiveAdmin.register BomPart do
  config.batch_actions = false	
  #config.clear_sidebar_sections! 
  config.comments = false
  belongs_to :bom

  collection_action :part_number_sel do
    @part_numbers = PartNumber.metasearch(params[:q]).page(params[:page]).per(5)
    respond_to do |format|
      format.json {render :json => @part_numbers.map{|pn| [pn.id, "#{pn.code} : #{pn.name}"]}}
      format.js 
    end
  end

  index do
  	column :id  
  	column :part_number do |part|
  	  "#{part.part_number.name}:(#{part.part_number.code})"
  	end
  	column :amount
  	column :location
  	column :comments
  	default_actions
  end

  filter :location
  filter :part_number, :as => :select, :collection => proc {Bom.find(params[:bom_id]).bom_parts.map{|part| [part.part_number.name, part.part_number.id]}}
  #filter :comments 

  form do |f|
  #  f.inputs do       
  #    f.input :part_number, :as => :select, :collection => f.object.new_record?? []:f.object.part_number.similar_parts, :input_html => {:class => 'part_number_collection_in_bom_part'}
  #    f.input :amount
  #    f.input :location              
  #    f.input :comments
  #    f.form_buffers.last # bypass the bug where no field will be shown if the unless condition is not satisfied
  #  end                               
  #  f.actions
  #  render :partial => "form"
    if f.object.new_record?
      #paginated_collection PartNumber.page(params[:page]).per(10), :download_links => false do
      #  table_for (collection) do |pn|
      #    column :code
      #    column :supplier
      #    column :status
      #    column :description
      #  end
      #end
      #@part_numbers = PartNumber.page(params[:page]).per(10)
      #render :partial => "new_form", :locals => {part_numbers: PartNumber.page(params[:page]).per(5) }
      #render :partial => "pn_sel"
      render :partial => "new_form"
    else
      f.inputs :name => "Part Number" do
        f.input :part_number, :as => :select, :collection => f.object.part_number.similar_parts, :include_blank => false
      end
   
      f.inputs :name => "Other Info" do 
        f.input :amount
        f.input :location
        f.input :comments
      end 

      f.actions
    end
  end

  sidebar :part_number_filter, :only => [:new,:create] do
    if bom_part.part_number.nil?
      @part_number = bom_part.build_part_number
    else
      @part_number = bom_part.part_number
      logger.info "bom_part_part_number is "
    end
    #@part_number = bom_part.nil?? bom_part.part_number : bom_part.build_part_number
    render :partial => 'search'
  end 

  sidebar :parent_bom_info, :only => [:index] do
    attributes_table_for bom do
      row :name do "#{bom.name} (code: #{bom.code})" end
      row :total_number_of_categories
      row :total_number_of_items
      row :version
    end 
  end  

  controller do 
    before_filter :pre_action_proc

    def pre_action_proc
      case params[:action]
        when 'new'
        when 'update'
          #params[:component_category].merge!(:updated_by_email => current_admin_user.email)        
      end       
    end    

  end  
end
