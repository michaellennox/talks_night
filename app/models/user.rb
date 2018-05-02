# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :display_name, presence: true,
                           uniqueness: true
  validates :email, format: { with: /@/, message: 'is not a valid email' },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }
end
