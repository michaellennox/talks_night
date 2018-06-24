# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Editing a group', type: :feature do
  let!(:group) { FactoryBot.create(:group) }

  scenario 'A space owner can edit their group\'s details' do
    sign_in(group.owner)
    visit group_path(group)

    click_on 'Edit Details'

    expect(page).to have_current_path edit_group_path(group)

    fill_in 'Name', with: 'I Changed This Group'
    fill_in 'Description', with: 'Some other things get changed about the group'
    click_on 'Update Group'

    expect(page).to have_current_path group_path(group)

    expect(page).to have_content('I Changed This Group')
    expect(page).to have_content('Some other things get changed about the group')
  end
end
