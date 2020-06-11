# frozen_string_literal: true

require "rails_helper"

feature "User can create an answer to the question" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path question
    end

    scenario "can create answer", js: true do
      expect(page).to have_current_path(question_path(question))
      fill_in "Body", with: "Answer body"

      click_on "Answer"

      expect(page).to have_content "Answer body"
    end

    scenario "can't create answer with a blank body", js: true do
      click_on "Answer"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "answer with attached files", js: true do
      fill_in "Body", with: "text text text"

      attach_file "Files", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Answer"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  describe "Unauthenticated user" do
    scenario "can't create answer" do
      visit question_path question
      click_on "Answer"

      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
