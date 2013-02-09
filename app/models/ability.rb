class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    
    if user.superadmin?
      can :manage, :all
    end
    
    can :manage, user
  end
  
end
