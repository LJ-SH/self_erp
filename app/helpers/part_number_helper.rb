module PartNumberHelper
	def i18n_status_helper(status)
		I18n.t("active_admin.scopes.#{status}")
	end	
end