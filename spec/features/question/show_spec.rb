# frozen_string_literal: true

require "rails_helper"

feature "User can view question and their aswers" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario "Authenticated user can view questions" do
    sign_in(user)
    visit question_path question

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario "Unauthenticated user can view question and their aswers" do
    visit question_path question

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
