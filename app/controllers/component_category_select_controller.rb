#encoding: UTF-8  
class ComponentCategorySelectController < ActionController::Base
  def children_collection
  	unless params[:node].empty? 
        @children = ComponentCategory.find(params[:node]).children
  	  render :json => @children.map{|c| [c.id, c.name]}
  	else
  	  render :json => [["", I18n.t('form.category_sel_tip_option')]] 
  	end  	
  end

  def cc_code
  	unless params[:node].empty?
  		render :text => ComponentCategory.find(params[:node]).code_generator
  	else
  	end
  end
  
end