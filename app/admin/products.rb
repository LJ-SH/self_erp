ActiveAdmin.register Product do
  config.batch_actions = false
  config.comments = false

  index do
  	column :name
  	column :pcb_ver
  	column :bom_appendix do |pdt|
  	  pdt.bom_appendix_name
  	end
  	column :sw_appendix
  	#column :tool_appendix
  	#column :doc_appendix
  	column :comment
  	column :updated_by
  	column :updated_at
    actions  
  end

  filter :name, :as => :select, :collection => Product.all
  filter :pcb_ver, :as => :select, :collection => Product.uniq.pluck(:pcb_ver).reject(&:blank?)
  filter :bom_appendix
  filter :updated_by, :as => :select, :collection => Product.uniq.pluck(:updated_by).reject(&:blank?)
  filter :updated_at

  form do |f|
    render :partial => "form"
  end 

  show do |pdt|
    attributes_table do
      rows :name, :pcb_ver
      row   :bom_appendix do
        unless pdt.bom_appendix.blank? then
          link_to "#{pdt.bom_appendix_name}", "#{pdt.bom_appendix.url}" 
        end
      end 
      rows :sw_appendix, :tool_appendix, :doc_appendix, :comment, :updated_by, :created_at, :updated_at
    end
  end

end
