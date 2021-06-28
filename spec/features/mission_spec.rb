require 'rails_helper'

feature "mission list", type: :feature do

  scenario "ordered by created_at" do

    m1 = Mission.create!(title: "m1", content: "m1_content", start_at: Time.new(2021, 6, 28, 9, 50, 0), end_at: Time.new(2021, 6, 28, 10, 0, 0))
    m2 = Mission.create!(title: "m2", content: "m2_content", start_at: Time.new(2021, 6, 28, 9, 50, 0), end_at: Time.new(2021, 6, 28, 10, 0, 0))

    visit "/"

    expect(page.body).to match(/m1.*m2/m)

  end

end
