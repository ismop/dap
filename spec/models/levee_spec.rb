# == Schema Information
#
# Table name: levees
#

require 'rails_helper'

describe Levee do
  it { should validate_presence_of :name }
  it { should validate_inclusion_of(:threat_level).in_array(%w(none heightened severe)) }
  it { should validate_inclusion_of(:emergency_level).in_array(%w(none heightened severe)) }

  subject { build(:levee) }
  it 'should properly update threat level update date' do
    subject.update_attributes(threat_level_updated_at: Time.now - 3.hours)
    expect(subject.threat_level_updated_at).not_to be_within(3.minutes).of(Time.now)
    expect(subject.threat_level).to eq 'none'

    subject.threat_level = 'heightened'
    subject.save
    expect(subject.threat_level).to eq 'heightened'
    expect(subject.threat_level_updated_at).to be_within(3.minutes).of(Time.now)
  end

end