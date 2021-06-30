require 'rails_helper'

feature "mission list", type: :feature do
  before do
    u1 = User.create(email: "user1@gmail.com", password: "password")
    u2 = User.create(email: "user2@gmail.com", password: "password")
    m1 = u1.missions.create(title: "m1", content: "m1_content", start_at: Time.new(2062, 6, 27, 9, 50, 0), end_at: Time.new(2062, 7, 28, 10, 0, 0), status: 1, priority: 1)
    m2 = u1.missions.create(title: "m2", content: "m2_content", start_at: Time.new(2062, 6, 29, 9, 50, 0), end_at: Time.new(2062, 7, 26, 10, 0, 0), status: 0, priority: 3)
    m3 = u1.missions.create(title: "m3", content: "m3_content", start_at: Time.new(2062, 6, 28, 9, 50, 0), end_at: Time.new(2062, 7, 27, 10, 0, 0), status: 2, priority: 2)

    visit "/"
    # 未登入狀態前往首頁，會導向登入頁面，在這邊先登入
    within("#new_user") do
      fill_in "user_email", with: "user1@gmail.com"
      fill_in "user_password", with: "password"
    end
    click_button "commit"

  end

  scenario "ordered by created_at" do
    # 預設以建立時間排序
    expect(page.body).to match(/m1.*m2.*m3/m)
  end

  scenario "ordered by end_at with ransack" do
    click_link "sortEndAt" # sort_link :end_at 以結束時間排序

    expect(page.body).to match(/m2.*m3.*m1/m)
  end

  scenario "ordered by priority with ransack" do
    click_link "sortPriority" # sort_link :priority 以優先順序排序

    expect(page.body).to match(/m1.*m3.*m2/m)
  end

  scenario "search by title with ransack" do
    within("#mission_search") do # search for missions with title includes "m1"
      fill_in "q_title_cont", with: "m1"
    end
    click_button "commit"

    expect(page.body).to have_content("m1")
    expect(page.body).not_to have_content("m2")
  end

  scenario "search by status with ransack" do
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

  scenario "Unable to CRUD others missions" do
    click_link I18n.t("sign_out")

    within("#new_user") do
      fill_in "user_email", with: "user2@gmail.com"
      fill_in "user_password", with: "password"
    end
    click_button "commit"

    expect(page.body).not_to have_content("m2")
  end

end
