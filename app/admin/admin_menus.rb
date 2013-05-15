ActiveAdmin.register_page "menu_supplychain" do
  menu :label => I18n.t("menu_supplychain"), :priority => 2, :url => '#'
end

ActiveAdmin.register_page "menu_sales" do
  menu :label => I18n.t("menu_sales"), :priority => 4, :url => '#'
end

ActiveAdmin.register_page "menu_system_setting" do
  menu :label => I18n.t("menu_system_setting"), :priority => 20, :url => '#'
end