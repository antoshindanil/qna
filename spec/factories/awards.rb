# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    question
    user
    title { "MyString" }
  end
end
