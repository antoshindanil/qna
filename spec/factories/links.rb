# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    name { "MyString" }
    url { "https://github.com" }

    trait :invalid do
      url { "1234aasdf" }
    end

    trait :gist do
      url { "https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c" }
    end
  end
end
