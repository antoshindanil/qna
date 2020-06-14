# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question, type: :model do
  it { should have_many(:answers).order("best DESC, created_at").dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it "have many attached files" do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
