# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :group

  scope :scheduled, -> { where('starts_at > ?', Time.current) }
  scope :previous, -> { where('starts_at < ?', Time.current) }
  scope :by_start_asc, -> { order(:starts_at) }
  scope :by_start_desc, -> { order(starts_at: :desc) }

  validates :title, presence: true
end
