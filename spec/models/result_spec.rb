# == Schema Information
#
# Table name: results
#

require 'rails_helper'

describe Result do
  it { should validate_presence_of :scenario }
end