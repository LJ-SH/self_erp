ActiveAdmin.register Bom do
  config.batch_actions = false
  #config.clear_sidebar_sections!  
  config.comments = false

  scope :all
  scope :status_in_progress
  scope :status_pending_approval
  scope :status_active
  scope :status_outdated
  scope :status_transient

    active_admin_import :validate => false,
                        :col_sep => ';',
                        :back => :index ,
                        :before_import => proc{|importer|  Bom.delete_all},
                        :batch_size => 1000,
                        :timestamps => Time.now

  csv do
    column :name
    column :status
    column :description
  end  

  member_action :compare_bom do
    @bom = Bom.find(params[:id])
    @compare_options = {:result_display => 2, :bom_id => ''}
  end

  member_action :fetch_compare_results do
  end

  index :download_links => [:csv, :pdf] do
  	column :name do |bom|
  	  link_to bom.name, admin_bom_bom_parts_path(bom)
  	end
  	#column :code
  	column :status, :class => 'set_min_column_width' do |bom|
  	  status_tag(I18n.t("active_admin.scopes.#{bom.status}"))
  	end
  	#column :description
  	#column :prepared_by
  	column :approved_by
  	column :updated_at
    actions :defaults => true do |resource|
      link = link_to I18n.t('active_admin.clone_bom'), new_admin_bom_path(:parent_bom_id => resource.id), :class=>"member_link"
      link += link_to I18n.t('active_admin.compare_bom'), compare_bom_admin_bom_path(:id => resource.id), :class=>"member_link"
      link
    end      
  end  

  form do |f|
  	f.inputs do
      f.input :name
      f.input :parent_bom_id, :as => :select, :include_blank => false,
              :collection => f.object.parent_bom_collection
      f.input :code
      f.input :description
      f.input :version, :input_html => {:value => f.object.version || "1.0"}
      f.input :prepared_by, :input_html => {:value => f.object.prepared_by || current_admin_user.email, 
                                            :disabled => f.object.display_approved_by?}
      if f.object.display_approved_by?
        f.input :approved_by, :input_html => {:value => f.object.approved_by || current_admin_user.email,
                                              :disabled => f.object.model_fixed?}
      end
      f.input :status, :as => :select, :collection => f.object.status_select_collection.map{|r| [i18n_status_helper(r),r]},
              :include_blank => false
    end

    if (f.object.change_histories.empty? || f.object.change_histories.last.persisted?)
      f.object.change_histories.build(:updated_by => current_admin_user.email)
    end
    f.inputs :notes, :updated_by, :name => :bom_change_history, :for =>[:change_histories, f.object.change_histories.last]

    f.actions
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
  filter :created_at

  controller do 
    #rescue_from  NoMethodError do |e|
    #  flash[:error] = e.to_s
    #  redirect_to admin_boms_path
    #end

    def new
      if params[:parent_bom_id]
        @bom = Bom.new(:parent_bom_id => params[:parent_bom_id])
      end
      new!
    end
  end 
end
