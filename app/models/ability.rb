class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= AdminUser.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    can :read, ActiveAdmin::Page, :name => ["Dashboard", "menu_system_setting", "menu_supplychain", "menu_sales", "menu_rnd"]
    can [:read, :update], AdminUser, :id => user.id    

    case user.role
      when :role_super
        can :manage, :all
      when :role_admin       
        can :manage, AdminUser, :role => ROLE_DEFINITION.drop(1) << nil
        can :manage, ComponentCategory
        can :manage, Supplier
        can :manage, PartNumber
      when :role_material_controller
        can :crud, ComponentCategory
        can [:read], Supplier
      when :role_dev 
        can [:read], ComponentCategory
        can :manage, PartNumber
        can [:read], Supplier
      when :role_fin 
        can [:read], Supplier
      else #:role_others
        can [:read], Bom, :status => [:status_active]
        can [:read], BomPart, :bom_id => Bom.status_active
    end  

  end
end