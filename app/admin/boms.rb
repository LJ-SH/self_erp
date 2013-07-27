ActiveAdmin.register Bom do
  #config.batch_actions = false
  config.clear_sidebar_sections!  

  index do
    selectable_column
  	column :name do |bom|
  	  link_to bom.name, admin_bom_path(bom)
  	end
  	column :code
  	column :status, :class => 'set_min_column_width' do |bom|
  	  status_tag(I18n.t("active_admin.scopes.#{bom.status}"))
  	end
  	column :description
  	column :prepared_by
  	column :approved_by
  	column :updated_at
    actions :defaults => false do |resource|
      link = link_to I18n.t('active_admin.manage_parts'), [:admin, resource, :bom_parts], :class=>"member_link"
      link += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class=>"member_link edit_link"
      link += link_to I18n.t('active_admin.delete'), resource_path(resource),:method => :delete, :clas=>"member_link delete_link", :confirm => I18n.t('active_admin.delete_confirmation')
      link
    end      
  end  

  form do |f|
  	f.inputs do
      f.input :name
      f.input :code
      f.input :description
      f.input :version
      f.input :prepared_by
      f.input :approved_by
      if f.object.new_record?
        f.input :status, :as => :select, 
                :collection => BOM_STATUS_DEFINITION[0..0].map { |r| [I18n.t("active_admin.scopes.#{r}"),r]},
                :include_blank => false
      end
    end
    f.actions
  end 
end
