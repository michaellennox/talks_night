# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#title' do
    it 'is required to be present' do
      group = FactoryBot.build_stubbed(:group)
      event = Event.new(FactoryBot.attributes_for(:event, title: '', group: group))

      expect(event.valid?).to be false
      expect(event.errors[:title]).to include "can't be blank"
    end
  end

  describe '#group' do
    it 'is required' do
      event = Event.new(FactoryBot.attributes_for(:event, group: nil))

      expect(event.valid?).to be false
      expect(event.errors[:group]).to include 'must exist'
    end
  end
end
