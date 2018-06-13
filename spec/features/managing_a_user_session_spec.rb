# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Managing a user session', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  scenario 'A user can log in and out of talks night' do
    visit home_path

    within 'nav' do
      click_on 'Login'
    end

    expect(page).to have_current_path new_session_path

    within 'form' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Login'
    end

    expect(page).to have_current_path home_path

    within 'nav' do
      click_on 'Logout'
    end

    expect(page).to have_current_path home_path
    expect(page).not_to have_content 'Logout'
  end
end
