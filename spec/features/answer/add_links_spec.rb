# frozen_string_literal: true

require "rails_helper"

feature "User can add links to answer" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { "https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c" }

  scenario "User adds link when give an answer", js: true do
    sign_in(user)

    visit question_path(question)

    fill_in "Body", with: "My answer"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: gist_url

    click_on "Answer"

    within ".answers" do
      expect(page).to have_link "My gist", href: gist_url
    end
  end
end
