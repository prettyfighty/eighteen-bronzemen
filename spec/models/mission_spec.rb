require 'rails_helper'

RSpec.describe Mission, type: :model do
  # let(:mission){ Mission.new(tag: "travis")}
  it "測試Travis" do
    mission = Mission.new(tag: "travis")
    expect(mission.tag).to eq "travis"
  end
end
