class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    case controller_namespace
      when "Admin"
        can :manage, :all if user&.admin?
        can :manage, :admin_home if user&.admin?
      else
        can [:read], Product, status: :enabled
        return unless user&.enabled?
        can [:read, :create, :update], Order, user: user
    end
  end
end
