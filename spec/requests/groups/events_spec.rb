# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups/Events resource' do
  describe 'GET /groups/:url_slug/events/new' do
    subject(:get_new_event) { get new_group_event_path(group) }

    context 'when the group exists' do
      let!(:group) { FactoryBot.create(:group) }

      context 'and the user signed in is the group owner' do
        before { sign_in(group.owner) }

        it 'renders the new group event form' do
          get_new_event

          expect(response).to have_http_status :ok

          assert_select 'form[action=?][method=?]', group_events_path(group), 'post' do
            assert_select 'input[name=?]', 'event[title]'
            assert_select 'textarea[name=?]', 'event[description]'
            assert_select 'input[name=?][type=?]', 'event[starts_at]', 'datetime-local'
            assert_select 'input[name=?][type=?]', 'event[ends_at]', 'datetime-local'
            assert_select 'input[type=?]', 'submit'
          end
        end
      end

      context 'and the user signed in is not the group owner' do
        before { sign_up }

        it 'returns that the access is forbidden', :realistic_error_responses do
          get_new_event

          expect(response).to have_http_status :forbidden
        end
      end

      context 'and there is no user signed in' do
        it 'returns that the access is unauthorized', :realistic_error_responses do
          get_new_event

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_new_event

        expect(response).to have_http_status :not_found
      end
    end
  end
end
