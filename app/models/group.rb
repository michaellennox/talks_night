# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: false

  has_many :events, dependent: :restrict_with_exception
  has_many :talk_suggestions

  has_one :next_event, -> { scheduled.by_start_asc.limit(1) }, class_name: 'Event', inverse_of: :group
  has_many :upcoming_events, -> { scheduled.by_start_asc }, class_name: 'Event', inverse_of: :group
  has_many :previous_events, -> { previous.by_start_desc }, class_name: 'Event', inverse_of: :group

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
