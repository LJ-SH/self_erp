ActiveAdmin.register Supplier do
  config.batch_actions = false
  config.clear_sidebar_sections!

  scope :company_active, :default => true
  scope :company_outdated
  scope :company_transient

  # here is the portion for index, comment-by-LJ on 2-May-2013
  index do |s|
    column t 'table.supplier.company_name' do |s|
      unless s.company_profile.company_name.nil? then
        link_to "#{s.company_profile.company_name}", :action => :show, :id => s.id
      end
    end
    column t 'table.supplier.contact' do |s|
      s.company_profile.contact unless s.company_profile.contact.nil?
    end       
    column t 'table.supplier.sign_in_info' do |s|
      s.users.collect(&:email).join(',')
    end
    actions 
  end

  # customize filter panel, comment-by-LJ on 2-May-2013
  sidebar :filters, :only => :index do
    render :partial => 'search'
  end


  # here is the new/edit form part, comment-by-LJ on 2-May-2013
  form do |f|
    render :partial => "form"
  end

  # here is the part for show action, seperated into 2 column. comment-by-LJ on 2-May-2013
  show do |s|
    panel t 'label.supplier.company_profile' do
      attributes_table_for s.company_profile do 
        rows  :company_name,:company_addr, :postcode, :company_desc, :contact, :primary_phone, :secondary_phone,
              :distribution_list
        row   :appendix do
          unless s.company_profile.appendix.blank? then
            link_to "#{s.company_profile.appendix_name}", "#{s.company_profile.appendix.url}" 
          end
        end 
      end
    end

    panel t 'label.supplier.sign_in_info' do 
      table_for s.users do 
        column t('table.supplier.email') do |u| u.email end
      end
    end
  end

  sidebar I18n.t("label.supplier.basic_info"), :only => [:show] do
    attributes_table_for supplier do
      row :name
    end
    button_to t("link.supplier.back_to_suppliers_index"), {:action => :index}, :method => "get"
    #link_to "back_to_suppliers_index", admin_suppliers_path
  end

  # here are the controller portion, comment-by-LJ on 2-May-2013
  controller do
    def new
      @supplier = Supplier.new
      @supplier.users.build
      @supplier.build_company_profile
      new!
    end
  end
end
