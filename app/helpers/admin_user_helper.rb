module AdminUserHelper
  def i18n_role_helper(user)
	I18n.t "role.#{user.role}"
  end	
end