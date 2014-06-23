class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :update], Levee
      can [:read, :create], Measurement
      can [:read], Sensor
      can [:read], MeasurementNode
      can [:read], EdgeNode
      can [:read, :create, :update], Timeline
    end
  end
end
