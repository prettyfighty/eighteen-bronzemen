require 'rails_helper'

feature "mission list order", type: :feature do

  before do
    m1 = Mission.create!(title: "m1", content: "m1_content", start_at: Time.new(2022, 6, 27, 9, 50, 0), end_at: Time.new(2022, 7, 28, 10, 0, 0))
    m2 = Mission.create!(title: "m2", content: "m2_content", start_at: Time.new(2022, 6, 29, 9, 50, 0), end_at: Time.new(2022, 7, 26, 10, 0, 0))
    m3 = Mission.create!(title: "m3", content: "m3_content", start_at: Time.new(2022, 6, 28, 9, 50, 0), end_at: Time.new(2022, 7, 27, 10, 0, 0))
  end

  scenario "default by created_at" do

    visit "/"

    expect(page.body).to match(/m1.*m2.*m3/m)

  end

  scenario "ransack by end_at" do

    visit "/"

    click_link 'sortEndAt'

    expect(page.body).to match(/m2.*m3.*m1/m)

  end

end
