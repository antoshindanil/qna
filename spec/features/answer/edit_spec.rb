# frozen_string_literal: true

require "rails_helper"

feature "User can edit his answer" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question2) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario "Unauthenticated can not edit answer" do
    visit question_path(question)

    expect(page).not_to have_link "Edit"
  end

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path question
    end

    describe "edit his answer", js: true do
      background { visit question_path(question) }

      scenario "with no errors" do
        within "#answer-#{answer.id}" do
          click_on "Edit"

          fill_in "Answer", with: "edited answer"
          click_on "Save"

          expect(page).not_to have_content answer.body
          expect(page).to have_content "edited answer"
          expect(page).not_to have_selector "textarea"
        end
      end

      scenario "with errors" do
        within "#answer-#{answer.id}" do
          click_on "Edit"
          fill_in "Answer", with: ""
          click_on "Save"

          expect(page).to have_content answer.body
          expect(page).to have_selector "textarea"
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario "can add files" do
        within "#answer-#{answer.id}" do
          click_on "Edit"

          attach_file "Files", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on "Save"

          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
          expect(page).to have_content answer.body
        end
      end
    end
  end

  scenario "tries to edit other user's answer" do
    visit question_path question2
    expect(page).not_to have_link "Edit"
  end
end
