ActiveAdmin.register AdminUser do     
  menu :parent => "menu_system_setting"
  config.comments = false  
  config.batch_actions = false 
  config.sort_order = "id_asc"
  actions  :all, :except => :show  

  index do               
    selectable_column             
    column :user_name
    column :email                 
    column :role do |admin_user|
      i18n_role_helper(admin_user)
    end    
    column :organization
    column :telephone
    column :last_sign_in_at      
    default_actions                   
  end

  filter :user_name  
  filter :email
  filter :organization
  filter :last_sign_in_at                       

  form do |f|                         
    f.inputs I18n.t 'admin_users.admin_user_form_title' do       
      f.input :user_name
      f.input :email   
      f.input :password              
      f.input :password_confirmation  
      #if [:role_super, :role_admin].include?(current_admin_user.role)
      if current_admin_user.admin?
        @collection = ROLE_DEFINITION.dup.drop_while{|x| x>current_admin_user.role}
      else
        @collection = [current_admin_user.role]
      end
      f.input :role, :as => :select, :collection => @collection.map { |r| [I18n.t("role.#{r}"),r]}
      f.input :telephone
      f.input :organization
      f.form_buffers.last # bypass the bug where no field will be shown if the unless condition is not satisfied
    end                               
    f.actions                         
  end

  controller do
    def destroy
      @admin_user = AdminUser.find(params[:id])

      if @admin_user.is_current_admin_user?(current_admin_user)
          flash[:error] = t('admin_users.destroy_fails_if_current_admin_user')
          redirect_to :action => :index
          return
      end

      destroy!
      if @admin_user.errors[:base].any?
        flash[:error] ||= []
        flash[:error].concat(@admin_user.errors[:base])
      end      
    end

    def update
      # enable the account modification without password update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end

      # fault-tolerance enhancement - the new role assignment shall not higher than the current user
      if params[:admin_user][:role]
        unless current_admin_user.higher_rank? params[:admin_user][:role].to_sym
            flash[:error] = t('admin_users.insufficient_permission_on_role_assignment')
            redirect_to :action => :edit
            return
        end
      end
      update! # call original destory method      
    end
  end
                                
end                                   
