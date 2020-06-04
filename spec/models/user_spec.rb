# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  describe "user is author?" do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:question1) { create(:question, author: user1) }

    it "user is an author" do
      expect(user).to be_author_of(question)
    end

    it "user is't an author" do
      expect(user).not_to be_author_of(question1)
    end
  end
end
