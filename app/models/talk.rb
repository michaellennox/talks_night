# frozen_string_literal: true

class Talk < ApplicationRecord
  belongs_to :speaker, class_name: 'User', inverse_of: false

  validates :title, presence: true
end
