# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    question
    user
    name { "MyString" }
  end
end
