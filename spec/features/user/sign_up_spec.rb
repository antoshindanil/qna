# frozen_string_literal: true

require "rails_helper"

feature "User can sign up" do

  scenario "User tries to sign up with valid attributes" do

    visit new_user_registration_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button "Sign up"

    expect(page).to have_content "You have signed up successfully."
  end

  scenario "User tries to sign up with invalid password confirmation" do

    visit new_user_registration_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345612"
    click_button "Sign up"

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "User tries to sign up with invalid password length" do

    visit new_user_registration_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "1234"
    fill_in "Password confirmation", with: "1234"
    click_button "Sign up"

    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end
end
