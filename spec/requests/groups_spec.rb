# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups resource', type: :request do
  describe 'GET /groups/new' do
    subject(:get_new_group) { get new_group_path }

    context 'when signed in' do
      before { sign_up }

      it 'renders the page to claim the group' do
        get_new_group

        expect(response).to have_http_status :ok
        assert_select 'h1', "Claim Your Group's Space"
        assert_select 'form[action=?][method=?]', groups_path, 'post' do
          assert_select 'input[name=?]', 'group[name]'
          assert_select 'textarea[name=?]', 'group[description]'
          assert_select 'input[type=?]', 'submit'
        end
      end
    end

    context 'when not signed in' do
      it 'redirects to the sign up flow and sets return as the new group flow' do
        get_new_group

        expect(response).to redirect_to new_user_path
        expect(session[:login_return_path]).to eq new_group_path
      end
    end
  end

  describe 'POST /groups' do
    let(:group_attributes) { FactoryBot.attributes_for(:group) }

    subject(:post_groups) { post groups_path, params: { group: group_attributes } }

    context 'when signed in' do
      before { sign_up }

      context 'with valid params' do
        it 'creates the group and redirects to the group page' do
          expect { post_groups }.to change(Group, :count).by(1)

          group = Group.last
          expect(group).to have_attributes group_attributes
          expect(group.owner).to eq User.last
          expect(response).to redirect_to group_path(group)
        end
      end

      context 'with invalid params' do
        let(:group_attributes) { super().merge(name: '') }

        it 'does not create the group and displays the form with error messages' do
          expect { post_groups }.not_to change(Group, :count)

          expect(response).to have_http_status :unprocessable_entity
          assert_select 'form[action=?][method=?]', groups_path, 'post' do
            assert_select 'p.is-danger', "Name can't be blank"
          end
        end
      end
    end

    context 'when not signed in' do
      it 'redirects to the sign up flow and sets the return as the new group flow' do
        post_groups

        expect(response).to redirect_to new_user_path
        expect(session[:login_return_path]).to eq new_group_path
      end
    end
  end

  describe 'GET /groups/:url_slug' do
    subject(:get_group) { get group_path(group) }

    context 'when the group exists' do
      let(:group) { FactoryBot.create(:group) }

      shared_examples 'non-admin group page visibility' do
        it 'displays the group page with no management link' do
          get_group

          assert_select 'h1', group.name
          assert_select 'p', group.description
          assert_select 'a[href=?]', edit_group_path(group), count: 0
        end
      end

      context 'when the user is not logged in' do
        include_examples 'non-admin group page visibility'
      end

      context 'when the current user is not a group admin' do
        before { sign_up }

        include_examples 'non-admin group page visibility'
      end

      context 'when the current user is a group admin' do
        before { sign_in(group.owner) }

        it 'displays the group page with the management link' do
          get_group

          assert_select 'h1', group.name
          assert_select 'p', group.description
          assert_select 'a[href=?]', edit_group_path(group)
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_group

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'GET /groups/:url_slug/edit' do
    subject(:get_edit_group) { get edit_group_path(group) }

    context 'when the group exists' do
      let!(:group) { FactoryBot.create(:group) }

      context 'and the user signed in is the group owner' do
        before { sign_in(group.owner) }

        it 'renders the group editing form' do
          get_edit_group

          expect(response).to have_http_status :ok

          assert_select 'form[action=?][method=?]', group_path(group), 'post' do
            assert_select 'input[type=?][name=?][value=?]', 'hidden', '_method', 'patch'
            assert_select 'input[name=?][value=?]', 'group[name]', group.name
            assert_select 'textarea[name=?]', 'group[description]', group.description
            assert_select 'input[type=?]', 'submit'
          end
        end
      end

      context 'and the user signed in is not the group owner' do
        before { sign_up }

        it 'returns that the access is forbidden', :realistic_error_responses do
          get_edit_group

          expect(response).to have_http_status :forbidden
        end
      end

      context 'and there is no user signed in' do
        it 'returns that the access is unauthorized', :realistic_error_responses do
          get_edit_group

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_edit_group

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'PATCH /groups/:url_slug' do
    let(:new_atttributes) do
      {
        name: 'foo-bar-new-group',
        description: 'Making newer group updates since forever'
      }
    end

    subject(:patch_group) { patch group_path(group), params: { group: new_atttributes } }

    context 'when a group exists' do
      let(:group) { FactoryBot.create(:group) }

      context 'when the user signed in is a group administrator' do
        before { sign_in(group.owner) }

        context 'when the parameters passed are valid' do
          it 'updates the group and redirects to the group page' do
            patch_group

            expect(group.reload).to have_attributes(new_atttributes)
            expect(response).to redirect_to(group_path(group))
          end
        end

        context 'when the parameters passed are invalid' do
          let(:new_atttributes) { super().merge(name: '') }

          it 'renders the edit form with errors' do
            patch_group

            expect(response).to have_http_status :unprocessable_entity
            assert_select 'form[action=?][method=?]', group_path(group), 'post' do
              assert_select 'p.is-danger', "Name can't be blank"
            end
          end
        end
      end

      context 'when the user signed in is not a group administrator' do
        before { sign_up }

        it 'returns that the access is forbidden and does not change the group', :realistic_error_responses do
          patch_group

          expect(group.reload).not_to have_attributes(new_atttributes)
          expect(response).to have_http_status :forbidden
        end
      end

      context 'when there is no user signed in' do
        it 'returns that the access is unauthorized', :realistic_error_responses do
          patch_group

          expect(group.reload).not_to have_attributes(new_atttributes)
          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context 'when a group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        patch_group

        expect(response).to have_http_status :not_found
      end
    end
  end
end
