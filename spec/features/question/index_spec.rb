# frozen_string_literal: true

require "rails_helper"

feature "User can view questions" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario "Authenticated user can view questions" do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario "Unauthenticated user can view questions" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
