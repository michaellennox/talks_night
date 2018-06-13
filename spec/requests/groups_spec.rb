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

  describe 'GET /groups/:url_slug'
end
