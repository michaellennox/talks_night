# frozen_string_literal: true

class TalkSuggestion < ApplicationRecord
  belongs_to :talk
  belongs_to :group

  validates :speaker_contact, presence: true
end
