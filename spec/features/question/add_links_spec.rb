# frozen_string_literal: true

require "rails_helper"

feature "User can add links to question" do
  given(:user) { create(:user) }
  given(:gist_url) { "https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c" }
  given(:valid_url) { "https://github.com/antoshindanil" }
  given(:invalid_url) { "123koo" }

  scenario "User adds link when asks question", js: true do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "text text text"

    fill_in "Name", with: "valid link"
    fill_in "Url", with: valid_url

    click_on "Ask"
    within ".question-links" do
      expect(page).to have_link "valid link", href: valid_url
    end
  end

  scenario "User adds Gist link when asks question" do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "text text text"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: gist_url

    click_on "Ask"

    expect(page).to have_content `puts 'Hello, world!"`
  end

  scenario "User adds invalid link when asks question" do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "text text text"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: invalid_url

    click_on "Ask"

    expect(page).to have_content "Links url is not a valid URL"
    expect(page).not_to have_link "My gist", href: invalid_url
  end
end
