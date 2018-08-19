# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :group

  scope :scheduled, -> { where('starts_at > ?', Time.current) }
  scope :by_start, -> { order(:starts_at) }

  validates :title, presence: true
end
