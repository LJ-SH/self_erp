ActiveAdmin.register ProductionOrder do
  menu :parent => "menu_supplychain"
  config.comments = false 

  form do |f|
    render :partial => "form"
  end  

  collection_action :discover_associated_docs do
  end  
end
