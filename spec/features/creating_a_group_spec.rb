# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Creating a group', type: :feature do
  scenario 'A user is guided to creating a group from the homepage' do
    visit home_path
    click_on 'Claim Your Space'

    expect(page).to have_current_path new_user_path

    fill_in 'Display name', with: 'Test User'
    fill_in 'Email', with: 'test-user@example.com'
    fill_in 'Password', with: 'test-password'
    fill_in 'Password confirmation', with: 'test-password'
    click_on 'Create Account'

    expect(page).to have_current_path new_group_path

    fill_in 'Name', with: 'Example Group'
    fill_in 'Description', with: 'Many things about this group...'
    click_on 'Create Space'

    expect(page).to have_current_path group_path('example-group')

    expect(page).to have_content('Example Group')
    expect(page).to have_content('Many things about this group...')
  end
end
