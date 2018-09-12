# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Confirming talk for a scheduled talks night', type: :feature do
  let!(:group) { FactoryBot.create(:group) }
  let!(:event) { FactoryBot.create(:event, starts_at: 7.days.from_now, group: group) }
  let!(:talk_suggestion) { FactoryBot.create(:talk_suggestion, group: group) }

  scenario 'A group admin can confirm a talk for a specific talks night' do
    pending 'WIP'

    sign_in(group.owner)

    visit group_path(group)

    click_on 'Manage Speakers'

    # assert the page has details about how to contact the speaker
    # click to confirm the talk
    # assert still on the manage speakers page
    # assert page no longer has talk as a proposal but as a confirmed

    expect(true).to be false
  end
end
