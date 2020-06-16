# frozen_string_literal: true

require "rails_helper"

feature "User can add links to answer" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { "https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c" }
  given(:valid_url) { "https://github.com/antoshindanil" }
  given(:invalid_url) { "123koo" }

  scenario "User adds valid link when give an answer", js: true do
    sign_in(user)

    visit question_path(question)

    fill_in "Body", with: "My answer"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: valid_url

    click_on "Answer"

    within ".answers" do
      expect(page).to have_link "My gist", href: valid_url
    end
  end

  scenario "User adds Gist link when give an answer", js: true do
    sign_in(user)

    visit question_path(question)

    fill_in "Body", with: "My answer"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: gist_url

    click_on "Answer"

    within ".answers" do
      expect(page).to have_content `puts 'Hello, world!"`
    end
  end

  scenario "User adds invalid link when give an answer", js: true do
    sign_in(user)

    visit question_path(question)

    fill_in "Body", with: "My answer"

    fill_in "Name", with: "My gist"
    fill_in "Url", with: invalid_url

    click_on "Answer"

    expect(page).to have_content "Links url is not a valid URL"
    expect(page).not_to have_link "My gist", href: invalid_url
  end
end
