class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :update], Levee
    end
  end
end
