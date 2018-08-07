# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TalkSuggestion, type: :model do
  describe '#talk' do
    it 'is required' do
      group = FactoryBot.build_stubbed(:group)
      suggestion = TalkSuggestion.new(FactoryBot.attributes_for(:talk_suggestion, talk: nil, group: group))

      expect(suggestion.valid?).to be false
      expect(suggestion.errors[:talk]).to include 'must exist'
    end
  end

  describe '#group' do
    it 'is required' do
      talk = FactoryBot.build_stubbed(:talk)
      suggestion = TalkSuggestion.new(FactoryBot.attributes_for(:talk_suggestion, group: nil, talk: talk))

      expect(suggestion.valid?).to be false
      expect(suggestion.errors[:group]).to include 'must exist'
    end
  end

  describe '#speaker_contact' do
    it 'cannot be blank' do
      talk = FactoryBot.build_stubbed(:talk)
      group = FactoryBot.build_stubbed(:group)
      suggestion = TalkSuggestion.new(
        FactoryBot.attributes_for(:talk_suggestion, speaker_contact: '   ', talk: talk, group: group)
      )

      expect(suggestion.valid?).to be false
      expect(suggestion.errors[:speaker_contact]).to include "can't be blank"
    end
  end
end
