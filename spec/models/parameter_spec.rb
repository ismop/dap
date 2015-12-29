# == Schema Information
#
# Table name: parameters
#

require 'rails_helper'

describe Parameter do

  it 'should correctly handle monitoring scopes' do
    mps = []
    umps = []

    10.times do
      umps << create(:parameter, monitored: false)
      mps << create(:parameter, monitored: true)
    end

    expect(Parameter.count).to eq 20
    expect(Parameter.monitorable.count).to eq 10
    expect((Parameter.monitorable | mps).count).to eq 10

    for i in 0..4 do
      mps[i].monitoring_status = :up
      mps[i].save
    end

    expect(Parameter.monitorable.up.count).to eq 5
    expect(Parameter.monitorable.down.count).to eq 0
  end

end