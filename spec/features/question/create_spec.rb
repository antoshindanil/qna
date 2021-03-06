# frozen_string_literal: true

require "rails_helper"

feature "User can create question" do
  given(:user) { create(:user) }

  describe "Authenticated user" do
    background do
      sign_in(user)

      visit questions_path
      click_on "Ask question"
    end

    scenario "asks a question" do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"
      click_on "Ask"

      expect(page).to have_content "Your question successfully created."
      expect(page).to have_content "Test question"
      expect(page).to have_content "text text text"
    end

    scenario "asks a question with errors" do
      click_on "Ask"

      expect(page).to have_content "Title can't be blank"
    end

    scenario "asks question with attached files" do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"

      attach_file "Files", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Ask"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario "asks question with awards", js: true do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"

      fill_in "Award name", with: "Test Award"
      attach_file "Image", "#{Rails.root}/spec/fixtures/files/example.jpg"

      click_on "Ask"

      expect(page).to have_content "Test Award"
      expect(page).to have_link "example.jpg"
    end
  end

  scenario "Unauthenticated user tries to ask a question" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
