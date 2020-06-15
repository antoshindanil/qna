# frozen_string_literal: true

require "rails_helper"

feature "User can view their awards" do
  given(:user) { create(:user) }
  given!(:awards) { create_list(:award, 3, user: user) }

  background { sign_in(user) }

  scenario "User see rewards" do
    visit awards_path

    expect(page).to have_content "Awards"
    awards.each do |award|
      expect(page).to have_content award.question.title
      expect(page).to have_content award.name
    end
  end
end
