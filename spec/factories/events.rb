# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    starts_at '2018-08-10 07:53:43'
    ends_at '2018-08-10 09:53:43'
    description 'This talks night will be super awesome'
    sequence(:title) { |n| "SuperNight#{n}" }

    group
  end
end
