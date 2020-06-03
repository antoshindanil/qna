# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    body { "Answer text" }

    trait :invalid do
      body { nil }
    end
  end
end
