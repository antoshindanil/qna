# frozen_string_literal: true

require "rails_helper"
feature "User can select best answer" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }
  given!(:answer3) { create(:answer, question: question) }

  scenario "Unauthenticated user can't select best answer" do
    visit question_path(question)
    expect(page).not_to have_link "Select best!"
  end

  describe "Authenticated user" do
    background { sign_in(user) }

    scenario "select best answer for his question", js: true do
      visit question_path(question)

      within "#answer-#{answer1.id}" do
        click_on "Best"
        expect(page).to have_content "Best answer!"
        expect(page).not_to have_link "Best"
      end
    end

    scenario "tries select best answer for another question" do
      visit question_path(other_question)
      expect(page).not_to have_link "Best"
    end
  end
end
