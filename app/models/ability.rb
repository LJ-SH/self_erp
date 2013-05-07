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

    can :read, ActiveAdmin::Page, :name => "Dashboard"  
    can [:read, :update], AdminUser, :id => user.id    
    
    case user.role
    when :role_super
      can :manage, :all
    when :role_admin  
      can :manage, AdminUser, :role => ROLE_DEFINITION.drop(1) << nil
      can :manage, ComponentCategory
      can :manage, Supplier
    when :role_material_controller
      can :manage, ComponentCategory
      can [:read], Supplier
    when :role_dev
      can [:read], ComponentCategory
    when :role_fin 
      can [:read], Supplier
    else
    end  

  end
end