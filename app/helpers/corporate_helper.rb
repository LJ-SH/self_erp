module CorporateHelper
  def link_to_add_fields_corporate(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
	  fields = f.semantic_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
	    render(:partial => "/admin/corporate/"+association.to_s.singularize + "_fields", :locals => {:f => builder, :index => 'new_index'})
	  end
	link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end  
end