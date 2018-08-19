# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: false

  has_many :events, dependent: :restrict_with_exception

  has_one :next_event, -> { scheduled.by_start.limit(1) }, class_name: 'Event', inverse_of: :group

  validates :description, presence: true
  validates :name, presence: true,
                   uniqueness: true

  before_create :set_url_slug

  def to_param
    url_slug
  end

  def administered_by?(user)
    owner == user
  end

  private

  def set_url_slug
    self.url_slug = name.parameterize
  end
end
