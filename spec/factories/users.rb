# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[owner speaker] do
    sequence(:email) { |n| "user-#{n}@example.com" }
    sequence(:display_name) { |n| "ExampleUser-#{n}" }
    password 'TestPassword'
    password_confirmation 'TestPassword'
  end
end
