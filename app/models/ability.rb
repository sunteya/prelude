class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    can :manage, :all if user.superadmin?
    can :manage, user
  end
  
end
