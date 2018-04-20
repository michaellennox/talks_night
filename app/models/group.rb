# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: false

  validates :description, presence: true
  validates :name, presence: true,
                   uniqueness: true

  before_create :set_url_slug

  def to_param
    url_slug
  end

  private

  def set_url_slug
    self.url_slug = name.parameterize
  end
end
