class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.ceo?
      can :manage, :all
    elsif user.manager?
      can :manage, Recap
    else
      can :read, :all
    end
  end
end
