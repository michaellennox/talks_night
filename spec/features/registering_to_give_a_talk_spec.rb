# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Registering to give a talk', type: :feature do
  let!(:group) { FactoryBot.create(:group) }

  scenario 'A user is guided to sign up when they request to give a talk' do
    visit group_path(group)
    click_on "Speak at #{group.name}"

    expect(page).to have_current_path new_group_talk_path

    # fill in form displayed

    expect(page).to have_current_path group_path(group)

    # assert page shows speaker tools
  end
end
