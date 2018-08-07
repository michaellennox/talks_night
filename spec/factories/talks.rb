# frozen_string_literal: true

FactoryBot.define do
  factory :talk do
    title 'A very special talk'
    description 'Talking about all those things that are there'

    speaker
  end
end
