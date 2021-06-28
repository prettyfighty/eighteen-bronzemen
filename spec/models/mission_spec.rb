require 'rails_helper'

RSpec.describe Mission, type: :model do
  # let(:mission){ Mission.new(tag: "travis")}
  it "測試Travis" do
    mission = Mission.new(tag: "travis")
    expect(mission.tag).to eq "travis"
  end

  describe "validations" do
    it "presence" do
      mission = Mission.new(title: "", content: "", start_at: "", end_at: "")
      mission.save

      expect(mission.errors.full_messages.include?("Title #{I18n.t("errors.messages.blank")}")).to be true
      expect(mission.errors.full_messages.include?("Content #{I18n.t("errors.messages.blank")}")).to be true
      expect(mission.errors.full_messages.include?("Start at #{I18n.t("errors.messages.blank")}")).to be true
      expect(mission.errors.full_messages.include?("End at #{I18n.t("errors.messages.blank")}")).to be true
    end

    it "start-time" do
      mission = Mission.new(title: "", content: "", start_at: Time.now - 10.minutes, end_at: Time.now + 20.minutes)
      mission.save

      expect(mission.errors.full_messages.include?("Start at #{I18n.t("later_than_now")}")).to be true
    end

    it "end-time" do
      mission = Mission.new(title: "", content: "", start_at: Time.now + 10.minutes, end_at: Time.now + 2.minutes)
      mission.save

      expect(mission.errors.full_messages.include?("End at #{I18n.t("later_than_start_at")}")).to be true
    end
  end
  
end
