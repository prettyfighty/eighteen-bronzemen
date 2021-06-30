require 'rails_helper'

feature "sign up", type: :feature do

  before do
    visit "/user/sign_up"
  end

  scenario "blank" do
    within("#new_user") do
      fill_in "user_email", with: ""
      fill_in "user_password", with: ""
      fill_in "user_password_confirmation", with: ""
    end
    click_button "commit"

    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.password.blank"))
  end

  scenario "invalid and password confirmation" do
    within("#new_user") do
      fill_in "user_email", with: "123"
      fill_in "user_password", with: "123"
      fill_in "user_password_confirmation", with: ""
    end
    click_button "commit"

    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
  end

  scenario "successful" do
    within("#new_user") do
      fill_in "user_email", with: "123@123.123"
      fill_in "user_password", with: "123"
      fill_in "user_password_confirmation", with: "123"
    end
    click_button "commit"

    expect(page.body).to have_content(I18n.t("successfully_create_user"))
  end

  scenario "email taken" do
    within("#new_user") do
      fill_in "user_email", with: "123@123.123"
      fill_in "user_password", with: "123"
      fill_in "user_password_confirmation", with: "123"
    end
    click_button "commit"

    visit "/user/sign_up"
    within("#new_user") do
      fill_in "user_email", with: "123@123.123"
      fill_in "user_password", with: "123"
      fill_in "user_password_confirmation", with: "123"
    end
    click_button "commit"

    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
  end

end
