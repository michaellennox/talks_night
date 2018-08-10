# frozen_string_literal: true

FactoryBot.define do
  factory :talk_suggestion do
    speaker_contact 'My slack handle for the group is @person.barr'

    talk
    group
  end
end
