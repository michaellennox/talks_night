# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#email' do
    it 'is able to be searched for case insensitively' do
      user = FactoryBot.create(:user, email: 'CASEtest@example.com')

      expect(User.find_by(email: 'caseTEST@example.com')).to eq user
    end

    it 'has case preserved when persisted' do
      FactoryBot.create(:user, email: 'CASEtest@example.com')

      expect(User.find_by(email: 'caseTEST@example.com').email).to eq 'CASEtest@example.com'
    end

    it 'is required to be case insensitively unique' do
      FactoryBot.create(:user, email: 'CASEtest@example.com')
      new_user = User.new(FactoryBot.attributes_for(:user, email: 'caseTEST@example.com'))

      expect(new_user.valid?).to be false
      expect(new_user.errors[:email]).to include 'has already been taken'
    end

    it 'is required to be an email format' do
      new_user = User.new(FactoryBot.attributes_for(:user, email: 'imnotanemail'))

      expect(new_user.valid?).to be false
      expect(new_user.errors[:email]).to include 'is not a valid email'
    end
  end

  describe '#display_name' do
    it 'is required to be present' do
      new_user = User.new(FactoryBot.attributes_for(:user, display_name: '   '))

      expect(new_user.valid?).to be false
      expect(new_user.errors[:display_name]).to include "can't be blank"
    end

    it 'is required to be unique' do
      FactoryBot.create(:user, display_name: 'ATestUser')
      new_user = User.new(FactoryBot.attributes_for(:user, display_name: 'ATestUser'))

      expect(new_user.valid?).to be false
      expect(new_user.errors[:display_name]).to include 'has already been taken'
    end
  end

  describe '#password' do
    it 'is required to be a minimum length of 8' do
      new_user = User.new(FactoryBot.attributes_for(:user, password: 'example'))

      expect(new_user.valid?).to be false
      expect(new_user.errors[:password]).to include 'is too short (minimum is 8 characters)'
    end
  end
end
