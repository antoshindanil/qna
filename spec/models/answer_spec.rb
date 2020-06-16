# frozen_string_literal: true

require "rails_helper"

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :body }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it "have many attached files" do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "best answer validation if the answer is choosen as the best" do
    # rubocop:disable RSpec/LetSetup
    let!(:answer) { create(:answer, best: true) }
    # rubocop:enable RSpec/LetSetup

    it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe "best answer validation if the answer is not choosen as best answer" do
    # rubocop:disable RSpec/LetSetup
    let!(:answer) { create(:answer, best: false) }
    # rubocop:enable RSpec/LetSetup

    it { should_not validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe "#best" do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, best: true, question: question) }

    it "get best answer" do
      expect(question.answers.best).to eq(answer1)
    end
  end

  describe "#set_best" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer1) { create(:answer, best: true, question: question) }
    let!(:answer2) { create(:answer, best: false, question: question) }
    let!(:answer3) { create(:answer, best: false, question: question) }
    let!(:award) { create(:award, question: question) }

    before do
      answer2.set_best
      answer1.reload
      answer2.reload
      answer3.reload
    end

    it "set best answer" do
      expect(answer2).to be_best
    end

    it "assign an award answer author" do
      expect(award.user).to eq answer2.author
    end

    it "does not set best answer to others answers" do
      expect(answer1).not_to be_best
      expect(answer3).not_to be_best
    end
  end
end
