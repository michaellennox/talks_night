# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Talk, type: :model do
  describe '#title' do
    it 'is required to be present' do
      speaker = FactoryBot.build_stubbed(:user)
      new_talk = Talk.new(FactoryBot.attributes_for(:talk, title: '', speaker: speaker))

      expect(new_talk.valid?).to be false
      expect(new_talk.errors[:title]).to include "can't be blank"
    end
  end

  describe '#speaker' do
    it 'is required' do
      talk = Talk.new(FactoryBot.attributes_for(:talk, speaker: nil))

      expect(talk.valid?).to be false
      expect(talk.errors[:speaker]).to include 'must exist'
    end
  end
end
