# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Scheduling a talks night', type: :feature do
  let!(:group) { FactoryBot.create(:group) }

  scenario 'A group administrator can schedule a talks night for their group' do
    sign_in(group.owner)

    visit group_path(group)

    click_on 'Schedule A Talks Night'

    expect(page).to have_current_path new_group_event_path(group)

    fill_in 'Event Title', with: 'Super Night!'
    fill_in 'Description', with: 'Many things about this talk'
    fill_in 'Starts At', with: '2018-12-31T21:59:60Z'
    fill_in 'Ends At', with: '2018-12-31T23:59:60Z'

    click_on 'Schedule Event'

    expect(page).to have_current_path group_path(group)

    event = Event.last

    expect(event.title).to eq 'Super Night!'
    expect(event.group).to eq group
  end
end
