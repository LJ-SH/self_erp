ActiveAdmin.register Bom do
  config.batch_actions = false
  #config.clear_sidebar_sections!  
  config.comments = false

  scope :all
  scope :status_in_progress
  scope :status_pending_approval
  scope :status_active
  scope :status_transient
  scope :status_outdated

  member_action :compare_bom do
    authorize! :compare_bom, Bom
    @source_bom = Bom.find(params[:id])
    unless params[:target_bom].nil?
      @target_bom = Bom.find(params[:target_bom])
      @columns = Array.new
      headers = %w(part_number_code part_number_name amount location compare_result)

      @target_bom = Bom.find(params[:target_bom])
      @columns = Array.new
      headers = %w(part_number_code part_number_name amount location compare_result)
      source_pn_id_ary = @source_bom.bom_parts.map(&:part_number_id)
      target_pn_id_ary = @target_bom.bom_parts.map(&:part_number_id)
      missing_pn_id_ary = target_pn_id_ary - source_pn_id_ary

      # find out all Part_numbers which exist in target only 
      missing_bom_part_ary = @target_bom.bom_parts.keep_if{|x| missing_pn_id_ary.include?(x.part_number_id)} 
      missing_bom_part_ary.each do |bp|
        #bom_part_tmp = @target_bom.bom_parts.where(:part_number_id => id).first
        @columns << {headers[0] => bp.part_number.code,
                   headers[1] => bp.part_number.name,
                   headers[2] => "", headers[3] => "",
                   headers[4] => I18n.t("bom.compare.target_bom_only", :target_bom => @target_bom.name, :location => bp.location)}
      end
      
      # find out all Part_numbers which exist in source only
      surplus_pn_id_ary =  source_pn_id_ary - target_pn_id_ary
      surplus_bom_part_ary = @source_bom.bom_parts.keep_if{|x| surplus_pn_id_ary.include?(x.part_number_id)}
      surplus_bom_part_ary.each do |bp|
        #bom_part_tmp = @source_bom.bom_parts.where(:part_number_id => id).first
        @columns << {headers[0] => bp.part_number.code,
                   headers[1] => bp.part_number.name,
                   headers[2] => bp.amount, headers[3] => bp.location,
                   headers[4] => I18n.t("bom.compare.source_bom_only", :source_bom => @source_bom.name)}
      end 
      
      # find out all part_numbers which are different in source from in target
      part_info = %w(part_number_id location)
      diff_pn_ary = @source_bom.bom_parts.map{|x| x.attributes.values_at(*part_info)} - @target_bom.bom_parts.map{|x| x.attributes.values_at(*part_info)}
      diff_pn_ary.each do |diff_ary|
        id = diff_ary[0]
        next if surplus_pn_id_ary.include?(id)
        bom_part_tmp = @source_bom.bom_parts.where(:part_number_id => id).first
        @columns << {headers[0] => bom_part_tmp.part_number.code,
                   headers[1] => bom_part_tmp.part_number.name,
                   headers[2] => bom_part_tmp.amount, headers[3] => bom_part_tmp.location,
                   headers[4] => I18n.t("bom.compare.bom_part_diff", :target_bom => @target_bom.name, :location => @target_bom.bom_parts.where(:part_number_id => id).first.location)} 
      end      
      @columns = Kaminari.paginate_array(@columns).page(params[:page]).per(5)
    end
    respond_to do |format|
      format.html
      format.js 
      format.csv do
        csv_output =  CSV.generate({:col_sep => ";"}) do |csv|
                        csv << headers
                        @columns.each do |col|
                          csv << col.values
                        end
                      end              
        send_data csv_output, :filename => "#{@source_bom.name}-vs-#{@target_bom.name}-#{Time.now.to_date.to_s}.csv" 
      end 
    end    
  end

  #member_action :fetch_compare_results do
  #  @target_bom = Bom.find(params[:target_bom])
  #  #@bom_parts = @target_bom.bom_parts.page params[:page]
  #  @bom_parts = BomPart.scoped.page(params[:page]).per(5)
  #  respond_to do |format|
  #    format.js 
  #    format.csv {send_data @bom_parts.to_csv_result}
  #  end
  #end

  index :download_links => [:csv, :xml, :json] do 
  	column :name do |bom|
  	  link_to bom.name, admin_bom_bom_parts_path(bom)
  	end
  	column :code
  	column :status, :class => 'set_min_column_width' do |bom|
  	  status_tag(I18n.t("active_admin.scopes.#{bom.status}"))
  	end
  	#column :description
  	#column :prepared_by
  	column :approved_by
  	column :updated_at
    actions :defaults => true do |resource|
      if can? :compare_bom, Bom
        link = link_to I18n.t('active_admin.clone_bom'), new_admin_bom_path(:parent_bom_id => resource.id), :class=>"member_link"
      end
      if can? :create, Bom 
        link += link_to I18n.t('active_admin.compare_bom'), compare_bom_admin_bom_path(:id => resource.id), :class=>"member_link"
      end
      link
    end     
  end  

  form do |f|
    render :partial => "form"
  end

  show do |bom|
    attributes_table do
      rows :name, :description, :code, :version, :parent_bom_id   
      row  :status do
        I18n.t("active_admin.scopes.#{bom.status}")
      end
      rows :prepared_by, :approved_by, :created_at, :updated_at
    end

    panel t 'label.bom.change_history_info' do 
      table_for bom.change_histories, i18n: ChangeHistory do
        column :notes
        column :updated_by
        column :updated_at
      end
    end
  end

  filter :name
  filter :approved_by
  filter :created_at, :as => :date_range

  controller do 
    #authorize_resource

    def new
      authorize! [:new], Bom
      if params[:parent_bom_id]
        @bom = Bom.new(:parent_bom_id => params[:parent_bom_id])
      end
      new!
    end

    def index
      #authorize! [:index], Bom
      index!
    end
  end 
end

      #@target_bom = Bom.find(params[:target_bom])
      #@columns = Array.new
      #headers = %w(part_number_code part_number_name amount location compare_result)
      #
      #@target_bom = Bom.find(params[:target_bom])
      #@columns = Array.new
      #headers = %w(part_number_code part_number_name amount location compare_result)
      #source_pn_id_ary = @source_bom.bom_parts.map(&:part_number_id)
      #target_pn_id_ary = @target_bom.bom_parts.map(&:part_number_id)
      #missing_pn_id_ary = target_pn_id_ary - source_pn_id_ary
      #
      ## find out all Part_numbers which exist in target only 
      #missing_pn_id_ary = @target_bom.bom_parts.map(&:part_number_id) - @source_bom.bom_parts.map(&:part_number_id)
      #missing_bom_part_ary = @target_bom.bom_parts.dup.keep_if{|x| missing_pn_id_ary.include?(x.part_number_id)} 
      #missing_bom_part_ary.each do |bp|
      #  #bom_part_tmp = @target_bom.bom_parts.where(:part_number_id => id).first
      #  @columns << {headers[0] => bp.part_number.code,
      #             headers[1] => bp.part_number.name,
      #             headers[2] => "", headers[3] => "",
      #             headers[4] => I18n.t("bom.compare.target_bom_only", :target_bom => @target_bom.name, :location => bp.location)}
      #end
      #
      ## find out all Part_numbers in common and filter out all differen components by removing common ones
      #part_info = %w(part_number_id location)
      #common_pn_ary = @source_bom.bom_parts.map{|x| x.attributes.values_at(*part_info)} & @target_bom.bom_parts.map{|x| x.attributes.values_at(*part_info)}
      #common_pn_id_ary = common_pn_ary.map{|x| x[0]}      
      #diff_bom_part_ary = @source_bom.bom_parts.delete_if{|x| common_pn_id_ary.include?(x.part_number_id)}     
      #target_pn_id_ary = @target_bom.bom_parts.map(&:part_number_id)    
      #diff_bom_part_ary.each do |bp|
      #  if target_pn_id_ary.include?(bp.part_number_id)
      #    @columns << {headers[0] => bp.part_number.code,
      #               headers[1] => bp.part_number.name,
      #               headers[2] => bp.amount, headers[3] => bp.location,
      #               headers[4] => I18n.t("bom.compare.bom_part_diff", :target_bom => @target_bom.name, 
      #                              :location => BomPart.where(:part_number_id=>bp.part_number_id, :bom_id => params[:target_bom]).first.location)}          
      #  else
      #    @columns << {headers[0] => bp.part_number.code,
      #               headers[1] => bp.part_number.name,
      #               headers[2] => bp.amount, headers[3] => bp.location,
      #               headers[4] => I18n.t("bom.compare.source_bom_only", :source_bom => @source_bom.name)}          
      #  end
      #end      
      #@columns = Kaminari.paginate_array(@columns).page(params[:page]).per(5)