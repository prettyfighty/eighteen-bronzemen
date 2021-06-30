require 'rails_helper'

feature "session", type: :feature do
  before do
    User.create(email: "user@gmail.com", password: "password")
  end

  scenario "sign in and sign out" do
    visit "/"

    expect(page.body).to have_content(I18n.t("authenticate_user"))

    within("#new_user") do
      fill_in "user_email", with: "user@gmail.com"
      fill_in "user_password", with: "password"
    end
    click_button "commit"

    expect(page.body).to have_content(I18n.t("successfully_sign_in"))

    click_link I18n.t("sign_out")

    expect(page.body).to have_content(I18n.t("successfully_sign_out"))
  end

end
