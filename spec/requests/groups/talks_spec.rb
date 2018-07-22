# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups/Talks resource', type: :request do
  describe 'GET /groups/:url_slug/talks/new' do
    subject(:get_new_talk) { get new_group_talk_path(group) }

    context 'when the group exists' do
      let(:group) { FactoryBot.create(:group) }

      context 'when signed in' do
        before { sign_up }

        it 'renders the page to give a talk at the group' do
          get_new_talk

          expect(response).to have_http_status :ok
          assert_select 'form[action=?][method=?]', groups_talks_path(group), 'post' do
            assert_select 'input[name=?]', 'talk[name]'
            assert_select 'textarea[name=?]', 'talk[description]'
            assert_select 'input[type=?]', 'submit'
          end
        end
      end

      context 'when not signed in' do
        it 'redirects to the sign up flow and sets return as the new talk flow' do
          get_new_talk

          expect(response).to redirect_to new_user_path
          expect(session[:login_return_path]).to eq new_group_talk_path(group)
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_new_talk

        expect(response).to have_http_status :not_found
      end
    end
  end
end
