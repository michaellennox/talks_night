# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Test Group #{n}" }
    description 'Many special things happen here'

    owner
  end
end
