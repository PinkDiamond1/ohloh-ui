# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    association :account
    association :project
    title { Faker::Lorem.characters(number: 16) }
    comment { Faker::Lorem.characters(number: 1024) }
  end
end
