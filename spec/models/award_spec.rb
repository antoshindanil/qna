# frozen_string_literal: true

require "rails_helper"

RSpec.describe Award, type: :model do
  describe "associations" do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  it "has one attached file" do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
