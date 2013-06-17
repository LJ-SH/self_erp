ActiveAdmin.register_page "menu_supplychain" do
  menu :label => proc{I18n.t("menu_supplychain")}, :priority => 2, :url => '#'
end

ActiveAdmin.register_page "menu_sales" do
  menu :label => proc{I18n.t("menu_sales")}, :priority => 4, :url => '#'
end

ActiveAdmin.register_page "menu_rnd" do
  menu :label => proc{I18n.t("menu_rnd")}, :priority => 6, :url => '#'
end

ActiveAdmin.register_page "menu_system_setting" do
  menu :label => proc{I18n.t("menu_system_setting")}, :priority => 20, :url => '#'
end
