ActiveAdmin.register BomPart do
  config.batch_actions = false	
  #config.clear_sidebar_sections! 
  config.comments = false
  belongs_to :bom
  config.clear_action_items!

  action_item :only => [:index, :edit, :update] do
    link_to I18n.t('active_admin.new_model', model: active_admin_config.resource_label), new_resource_path
  end

  action_item :only => :show do
    link_to I18n.t('active_admin.edit_model', model: active_admin_config.resource_label), edit_resource_path(resource)
  end

  action_item :only => :show do
    link_to I18n.t('active_admin.delete_model', model: active_admin_config.resource_label), resource_path(resource),
            method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
  end  

  active_admin_import  :back => :index,
      :validate => true,
      :timestamps => true,
      :col_sep => ';',
      :template => "admin/bom_parts/import",
      :before_import => Proc.new{|importer| # initialization
                                            target_bom_id = importer.extra_options["bom_id"]
                                            BomPart.where(:bom_id => target_bom_id).delete_all
                                            header = true
                                            white_list_attr=%w(Part_number_id Amount Location Comments)
                                            white_list_idx=Array.new(white_list_attr.size)
                                            file_buffer=""
                                            File.foreach(importer.file.path) do |line|
                                              next if line.blank?
                                              line_ary = line.strip.split(";")
                                              if header
                                                next unless line_ary.size > 1
                                                header = false
                                                white_list_idx = white_list_attr.map {|x| line_ary.index(x)}
                                                if white_list_idx.include?(nil)
                                                  raise I18n.t('active_admin_import.file_format_error')
                                                end
                                                file_buffer << [white_list_attr, "Bom_id"].flatten.join(";").concat("\n")
                                              else
                                                file_buffer << [line_ary.values_at(*white_list_idx), target_bom_id].flatten.join(";").concat("\n")
                                              end
                                            end
                                            #logger = Logger.new(STDOUT)                                            
                                            #logger.info 'buffer prepared ready ----------------'
                                            #logger.info file_buffer
                                            File.open(importer.file.path, "w+") { |file| file << file_buffer }
                                },
      :fetch_extra_options_from_params => ["bom_id"],
      :resource_class => nil,
      :resource_label => nil
      #:headers => true,
      #:headers_rewrites => {"Part Number" => :part_number_id}

  csv :default => true do
    column :id
    column("Bom_id") {|bom_part| bom_part.bom_id}
    column("Bom") {|bom_part| bom_part.bom.name}
    column("Part_number_id") {|bom_part| bom_part.part_number_id} 
    column("Part Number") {|bom_part| bom_part.part_number.name}
    column :amount
    column :location
    column :comments
    column :created_at
    column :updated_at
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
    #f.semantic_errors *f.object.errors.keys
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
        when 'do_import'
          params[:active_admin_import_model].merge!(:bom_id => params[:bom_id]) unless params[:active_admin_import_model].nil?
          #logger.info params[:active_admin_import_model]
          #logger.info params[:bom_id]
        else 
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


