# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Registering to give a talk', type: :feature do
  let!(:group) { FactoryBot.create(:group) }

  scenario 'A user is guided to sign up when they request to give a talk' do
    visit group_path(group)
    click_on 'Speak Here!'

    expect(page).to have_current_path new_user_path

    fill_in 'Display name', with: 'Test Speaker'
    fill_in 'Email', with: 'test-speaker@example.com'
    fill_in 'Password', with: 'test-password'
    fill_in 'Password confirmation', with: 'test-password'
    click_on 'Create Account'

    expect(page).to have_current_path new_group_talk_path(group)

    # fill in form displayed

    expect(page).to have_current_path group_path(group)

    # assert page shows speaker tools
  end
end
