# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '#name' do
    it 'is required to be present' do
      owner = FactoryBot.create(:user)
      new_group = Group.new(FactoryBot.attributes_for(:group, name: '   ', owner_id: owner.id))

      expect(new_group.valid?).to be false
      expect(new_group.errors[:name]).to include "can't be blank"
    end

    it 'is required to be unique' do
      FactoryBot.create(:group, name: 'Test Group Uniq')
      owner = FactoryBot.create(:user)
      new_group = Group.new(FactoryBot.attributes_for(:group, name: 'Test Group Uniq', owner_id: owner.id))

      expect(new_group.valid?).to be false
      expect(new_group.errors[:name]).to include 'has already been taken'
    end
  end

  describe '#description' do
    it 'is required to be present' do
      owner = FactoryBot.create(:user)
      new_group = Group.new(FactoryBot.attributes_for(:group, description: '   ', owner_id: owner.id))

      expect(new_group.valid?).to be false
      expect(new_group.errors[:description]).to include "can't be blank"
    end
  end

  describe '#url_slug' do
    it 'is populated before creation with a url friendly name' do
      group = FactoryBot.create(:group, name: 'A Name 5', url_slug: nil)

      expect(group.url_slug).to eq 'a-name-5'
    end
  end

  describe '#owner' do
    it 'is the user assigned as the owner of the group' do
      owner = FactoryBot.create(:user)
      group = FactoryBot.create(:group, owner_id: owner.id)

      expect(group.owner).to eq owner
    end

    it 'is required' do
      group = Group.new(FactoryBot.attributes_for(:group, owner: nil))

      expect(group.valid?).to be false
      expect(group.errors[:owner]).to include 'must exist'
    end
  end

  describe '#to_param' do
    it 'is the url_slug' do
      group = FactoryBot.build_stubbed(:group, url_slug: 'foo-bar-test')

      expect(group.to_param).to eq 'foo-bar-test'
    end
  end

  describe '#administered_by?' do
    let(:group) { FactoryBot.build_stubbed(:group) }

    it 'is true for the group owner' do
      expect(group.administered_by?(group.owner)).to be true
    end

    it 'is false for any other user' do
      other_user = FactoryBot.build_stubbed(:user)

      expect(group.administered_by?(other_user)).to be false
    end
  end
end
