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
          assert_select 'form[action=?][method=?]', group_talks_path(group), 'post' do
            assert_select 'input[name=?]', 'talk[title]'
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

  describe 'POST /groups/:url_slug/talks' do
    let(:talk_attributes) { FactoryBot.attributes_for(:talk) }

    subject(:post_talks) { post group_talks_path(group), params: { talk: talk_attributes } }

    context 'when the group exists' do
      let(:group) { FactoryBot.create(:group) }

      context 'when signed in' do
        let(:speaker) { FactoryBot.create(:user) }

        before { sign_in(speaker) }

        context 'with valid parameters' do
          it 'creates the group and redirects to the talk suggestions path' do
            expect { post_talks }.to change(Talk, :count).by(1)

            talk = Talk.last
            expect(talk).to have_attributes talk_attributes
            expect(talk.speaker).to eq speaker
            expect(response).to redirect_to new_group_talk_suggestion_path(group, talk_id: talk.id)
          end
        end

        context 'with invalid paramters' do
          let(:talk_attributes) { super().merge(title: '') }

          it 'renders the page to resubmit data with error messages present' do
            expect { post_talks }.not_to change(Talk, :count)

            expect(response).to have_http_status :unprocessable_entity
            assert_select 'form[action=?][method=?]', group_talks_path(group), 'post' do
              assert_select 'p.is-danger', "Title can't be blank"
            end
          end
        end
      end

      context 'when not signed in' do
        it 'redirects to the sign up flow and sets return as the new talk flow' do
          post_talks

          expect(response).to redirect_to new_user_path
          expect(session[:login_return_path]).to eq new_group_talk_path(group)
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        post_talks

        expect(response).to have_http_status :not_found
      end
    end
  end
end
