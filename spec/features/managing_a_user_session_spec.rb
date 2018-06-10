# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Managing a user session', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  scenario 'A user can log in and out of talks night' do
    visit home_path
    click_on 'Login'

    expect(page).to have_current_path new_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Login'

    expect(page).to have_current_path home_path

    click_on 'Logout'

    expect(page).to have_current_path home_path
    expect(page).not_to have_content 'Logout'
  end
end
