# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Viewing events for a group', type: :feature do
  let!(:group) { FactoryBot.create(:group) }
  let!(:future_event) { FactoryBot.create(:event, starts_at: 7.days.from_now, group: group) }
  let!(:past_event) { FactoryBot.create(:event, starts_at: 9.days.ago, group: group) }

  scenario 'A visitor to a group page can see event information' do
    pending 'WIP'

    visit group_path(group)

    expect(page).to have_content(future_event.title)

    click_on 'Events'

    expect(page).to have_current_path group_events_path(group)

    within '#upcoming-events' do
      expect(page).to have_content(future_event.title)
    end

    within '#previous-events' do
      expect(page).to have_content(past_event.title)
    end

    within '#upcoming-events' do
      click_on 'More Info'
    end

    expect(page).to have_current_path group_event_path(group, future_event)

    # assert that confirmed speakers for the future event are visible on page
    expect(true).to be false
  end
end
