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

    fill_in "What's the title of your talk?", with: 'My awesome talk'
    fill_in 'Tell us a bit more about it!', with: 'many things I can tell you about this talk'
    click_on 'Continue'

    expect(page).to have_current_path new_group_talk_suggestion_path(group, talk_id: Talk.last.id)

    fill_in "We're looking forwards to speaking to you! How shall we get in touch?", with: 'My contact is foobar'
    click_on 'Propose Talk'

    expect(page).to have_current_path group_path(group)
  end
end
