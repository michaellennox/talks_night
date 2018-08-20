# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :group

  validates :title, presence: true
end
