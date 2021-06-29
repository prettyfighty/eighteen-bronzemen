require 'rails_helper'

feature "mission list", type: :feature do
  before do
    u1 = User.create(email: "user@gmail.com", password: "password")
    m1 = u1.missions.create(title: "m1", content: "m1_content", start_at: Time.new(2062, 6, 27, 9, 50, 0), end_at: Time.new(2062, 7, 28, 10, 0, 0), status: 1, priority: 1)
    m2 = u1.missions.create(title: "m2", content: "m2_content", start_at: Time.new(2062, 6, 29, 9, 50, 0), end_at: Time.new(2062, 7, 26, 10, 0, 0), status: 0, priority: 3)
    m3 = u1.missions.create(title: "m3", content: "m3_content", start_at: Time.new(2062, 6, 28, 9, 50, 0), end_at: Time.new(2062, 7, 27, 10, 0, 0), status: 2, priority: 2)
  end

  scenario "ordered by created_at" do
    visit "/"

    expect(page.body).to match(/m1.*m2.*m3/m)
  end

  scenario "ordered by end_at with ransack" do
    visit "/"

    click_link "sortEndAt" # sort_link :end_at

    expect(page.body).to match(/m2.*m3.*m1/m)
  end

  scenario "ordered by priority with ransack" do
    visit "/"

    click_link "sortPriority" # sort_link :end_at

    expect(page.body).to match(/m1.*m3.*m2/m)
  end

  scenario "search by title with ransack" do
    visit "/"

    within("#mission_search") do # search for missions with title includes "m1"
      fill_in "q_title_cont", with: "m1"
    end
    click_button "commit"

    expect(page.body).to have_content("m1")
    expect(page.body).not_to have_content("m2")
  end

  scenario "search by status with ransack" do
    visit "/"

    within("#mission_search") do # search for missions pending
      select I18n.t("enums.mission.status.pending"), from: "q_status_eq"
    end
    click_button "commit"

    expect(page.body).to have_content("m2")
    expect(page.body).not_to have_content("m1")

    within("#mission_search") do # search for missions done
      select I18n.t("enums.mission.status.done"), from: "q_status_eq"
    end
    click_button "commit"

    expect(page.body).to have_content("m3")
    expect(page.body).not_to have_content("m2")
  end
end
