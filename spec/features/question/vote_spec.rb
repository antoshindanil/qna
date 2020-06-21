# frozen_string_literal: true

require "rails_helper"

feature "User can vote for the question" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, author: user) }

  scenario "Unauthenticated user can't vote" do
    visit question_path(question)
    expect(page).not_to have_link "Up!"
    expect(page).not_to have_link "Down!"
  end

  describe "Authenticated user" do
    background { sign_in(user) }

    scenario "can vote up for the question they like", js: true do
      visit question_path(question)

      within "#question-vote" do
        click_on "Up!"
        expect(page).not_to have_link "Up!"
        expect(page).not_to have_link "Down!"
        expect(page).to have_link "Cancel vote"
        within ".rating" do
          expect(page).to have_content "1"
        end
      end
    end

    scenario "can vote down for the question they like", js: true do
      visit question_path(question)

      within "#question-vote" do
        click_on "Down!"
        expect(page).not_to have_link "Up!"
        expect(page).not_to have_link "Down!"
        expect(page).to have_link "Cancel vote"
        within ".rating" do
          expect(page).to have_content "-1"
        end
      end
    end

    scenario "can cancel their vote", js: true do
      visit question_path(question)

      within "#question-vote" do
        click_on "Up!"
        expect(page).not_to have_link "Up!"
        within ".rating" do
          expect(page).to have_content "1"
        end
        click_on "Cancel vote"
        expect(page).to have_link "Up!"

        within ".rating" do
          expect(page).to have_content "0"
        end
      end
    end

    scenario "tries to vote for their question" do
      visit question_path(user_question)

      within "#question-vote" do
        expect(page).not_to have_link "Up!"
        expect(page).not_to have_link "Down!"
      end
    end
  end
end
