# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups/TalkSuggestions resource', type: :request do
  describe 'GET /groups/:url_slug/talk_suggestions/new' do
    subject(:get_new_talk_suggestion) { get new_group_talk_suggestion_path(group, talk_id: talk.id) }

    context 'when the group and talk exist' do
      let(:group) { FactoryBot.create(:group) }
      let(:talk) { FactoryBot.create(:talk) }

      context 'when the speaker for the talk is signed in' do
        before { sign_in(talk.speaker) }

        it 'renders the page to give final contact information' do
          get_new_talk_suggestion

          expect(response).to have_http_status :ok
          assert_select 'form[action=?][method=?]', group_talk_suggestions_path(group), 'post' do
            assert_select 'input[name=?][type=?][value=?]', 'talk_id', 'hidden', talk.id.to_s
            assert_select 'textarea[name=?]', 'talk_suggestion[speaker_contact]'
            assert_select 'input[type=?]', 'submit'
          end
        end
      end

      context 'when a user who is not the talk speaker is signed in' do
        before { sign_up }

        it 'returns unauthorised', :realistic_error_responses do
          get_new_talk_suggestion

          expect(response).to have_http_status :forbidden
        end
      end

      context 'when not signed in' do
        it 'redirects to the sign up flow and sets return as the new talk suggestion flow' do
          get_new_talk_suggestion

          expect(response).to redirect_to new_user_path
          expect(session[:login_return_path]).to eq new_group_talk_suggestion_path(group, talk_id: talk.id)
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }
      let(:talk) { FactoryBot.create(:talk) }

      it 'returns a not found', :realistic_error_responses do
        get_new_talk_suggestion

        expect(response).to have_http_status :not_found
      end
    end

    context 'when the group does exist but talk does not' do
      let(:group) { FactoryBot.create(:group) }
      let(:talk) { Talk.new }

      it 'returns a not found', :realistic_error_responses do
        get_new_talk_suggestion

        expect(response).to have_http_status :not_found
      end
    end

    context 'when the group does exist but no talk is provided' do
      let(:group) { FactoryBot.create(:group) }

      subject(:get_new_talk_suggestion) { get new_group_talk_suggestion_path(group) }

      it 'returns a not found', :realistic_error_responses do
        get_new_talk_suggestion

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /groups/:url_slug/talks' do
    let(:talk_suggestion_attributes) { FactoryBot.attributes_for(:talk_suggestion) }

    subject(:post_talk_suggestions) do
      post group_talk_suggestions_path(group), params: { talk_suggestion: talk_suggestion_attributes, talk_id: talk.id }
    end

    context 'when the group and talk exist' do
      let(:group) { FactoryBot.create(:group) }
      let(:talk) { FactoryBot.create(:talk) }

      context 'when the speaker for the talk is signed in' do
        before { sign_in(talk.speaker) }

        context 'with valid parameters' do
          it 'creates the talk suggestion and redirects to the group path' do
            expect { post_talk_suggestions }.to change(TalkSuggestion, :count).by(1)

            suggestion = TalkSuggestion.last
            expect(suggestion).to have_attributes talk_suggestion_attributes
            expect(suggestion.talk).to eq talk
            expect(suggestion.group).to eq group
            expect(response).to redirect_to group_path(group)
          end
        end

        context 'with invalid paramters' do
          let(:talk_suggestion_attributes) { super().merge(speaker_contact: '') }

          it 'renders the page to resubmit data with error messages present' do
            expect { post_talk_suggestions }.not_to change(TalkSuggestion, :count)

            expect(response).to have_http_status :unprocessable_entity
            assert_select 'form[action=?][method=?]', group_talk_suggestions_path(group), 'post' do
              assert_select 'p.is-danger', "Speaker contact can't be blank"
            end
          end
        end
      end

      context 'when a user who is not the talk speaker is signed in' do
        before { sign_up }

        it 'returns unauthorised', :realistic_error_responses do
          post_talk_suggestions

          expect(response).to have_http_status :forbidden
        end
      end

      context 'when not signed in' do
        it 'redirects to the sign up flow and sets return as the new talk suggestion flow' do
          post_talk_suggestions

          expect(response).to redirect_to new_user_path
          expect(session[:login_return_path]).to eq new_group_talk_suggestion_path(group, talk_id: talk.id)
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }
      let(:talk) { FactoryBot.create(:talk) }

      it 'returns a not found', :realistic_error_responses do
        post_talk_suggestions

        expect(response).to have_http_status :not_found
      end
    end

    context 'when the group does exist but talk being suggested does not' do
      let(:group) { FactoryBot.create(:group) }
      let(:talk) { Talk.new }

      it 'returns a not found', :realistic_error_responses do
        post_talk_suggestions

        expect(response).to have_http_status :not_found
      end
    end
  end
end
