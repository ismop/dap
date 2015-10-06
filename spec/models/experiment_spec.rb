# == Schema Information
#
# Table name: experiments
#

require 'rails_helper'

describe Experiment do

  it 'should automatically manufacture a valid experiment' do
    e = create(:experiment)
    expect(e).to be_valid
  end

end