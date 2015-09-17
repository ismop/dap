class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read], BudokopSensor
      can [:read], DeviceAggregation
      can [:read], Device
      can [:read], EdgeNode
      can [:read, :update], Levee
      can [:read], MeasurementNode
      can [:read, :create], Measurement
      can [:read], NeosentioSensor
      can [:read], Parameter
      can [:read], Pump
      can [:read], FiberOpticNode
      can [:read, :create, :update], Result
      can [:read, :get_profile_for_selection], Profile
      can [:read], Section
      can [:read], Sensor
      can [:read, :create, :update], Timeline
      can [:create, :read, :update, :destroy], ThreatAssessment
      can [:create, :read, :update, :destroy], Context
    end
  end
end
