# frozen_string_literal: true

FactoryBot.define do
  factory :monthly_commit_history do
    association :analysis
    json { nil }
  end
end
