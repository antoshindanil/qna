# frozen_string_literal: true

require "rails_helper"

feature "Author can delete attached files" do
  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:question) { create(:question, author: user) }

  context "when author", js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in "Body", with: "answer body"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb"]

      click_on "Answer"
    end

    scenario "it has file" do
      expect(page).to have_content "rails_helper.rb"
    end

    scenario "can delete answer's files" do
      click_on "Delete file"

      expect(page).not_to have_content "rails_helper.rb"
    end
  end

  context "when unauthenticated user", js: true do
    scenario "tries to delete answer's files" do
      visit question_path(question)
      expect(page).not_to have_content "Delete file"
    end
  end

  context "when non-author", js: true do
    scenario "tries to delete answer's files" do
      file = fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      question1 = create(:question, author: user)
      create(:answer, author: user, files: [file])

      sign_in(user1)

      visit question_path(question1)

      expect(page).not_to have_content "Delete file"
    end
  end
end
