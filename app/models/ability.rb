class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :update], Levee
      can [:read, :create], Measurement
      can [:read], Sensor
      can [:read, :get_profiles_for_selection], Profile
      can [:read], MeasurementNode
      can [:read], EdgeNode
      can [:read, :create, :update], Timeline
      can [:create, :read, :update, :destroy], Experiment
      can [:read, :create, :update], Result
    end
  end
end
