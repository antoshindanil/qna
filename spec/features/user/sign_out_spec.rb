# frozen_string_literal: true

require "rails_helper"

feature "User can sign out" do
  given(:user) { create(:user) }

  scenario "Registered user tries to sign out" do
    sign_in(user)

    visit new_user_session_path
    click_on "Log out"

    expect(page).to have_content "Signed out successfully."
    expect(page).to have_content "Sign in"
  end
end
