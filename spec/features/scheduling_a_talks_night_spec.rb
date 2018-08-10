# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Scheduling a talks night', type: :feature do
  let!(:group) { FactoryBot.create(:group) }

  scenario 'A group administrator can schedule a talks night for their group' do
    pending 'feature WIP'

    sign_in(group.owner)

    visit group_path(group)

    click_on 'Schedule A Talks Night'

    expect(page).to have_current_path new_group_talks_night_path(group)

    # fill in the new talks night form

    expect(page).to have_current_path group_path(group)

    # assert that the page has a next talks night component with the night info
  end
end
