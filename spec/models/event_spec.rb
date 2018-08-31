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

  describe '.scheduled' do
    it 'returns those events due to start in the future' do
      future_event1 = FactoryBot.create(:event, starts_at: 21.days.from_now)
      future_event2 = FactoryBot.create(:event, starts_at: 7.days.from_now)
      past_event = FactoryBot.create(:event, starts_at: 1.day.ago)

      result = Event.scheduled

      expect(result).to include(future_event1, future_event2)
      expect(result).not_to include(past_event)
    end
  end

  describe '.previous' do
    it 'returns those events that have already taken place' do
      past_event1 = FactoryBot.create(:event, starts_at: 21.days.ago)
      past_event2 = FactoryBot.create(:event, starts_at: 7.days.ago)
      future_event = FactoryBot.create(:event, starts_at: 1.day.from_now)

      result = Event.previous

      expect(result).to include(past_event1, past_event2)
      expect(result).not_to include(future_event)
    end
  end

  describe '.by_start_asc' do
    it 'orders events by start date' do
      far_future_event = FactoryBot.create(:event, starts_at: 21.days.from_now)
      soon_future_event = FactoryBot.create(:event, starts_at: 7.days.from_now)
      past_event = FactoryBot.create(:event, starts_at: 1.day.ago)

      result = Event.by_start_asc

      expect(result).to eq [past_event, soon_future_event, far_future_event]
    end
  end

  describe '.by_start_desc' do
    it 'orders events by start date descending' do
      far_future_event = FactoryBot.create(:event, starts_at: 21.days.from_now)
      soon_future_event = FactoryBot.create(:event, starts_at: 7.days.from_now)
      past_event = FactoryBot.create(:event, starts_at: 1.day.ago)

      result = Event.by_start_desc

      expect(result).to eq [far_future_event, soon_future_event, past_event]
    end
  end
end
