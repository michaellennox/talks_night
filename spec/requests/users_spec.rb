# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users resource', type: :request do
  describe 'GET /users/new' do
    subject(:get_new_user) { get new_user_path }

    it 'renders the page to sign up' do
      get_new_user

      expect(response).to have_http_status :ok
      assert_select 'h1', 'Create Your Account'
      assert_select 'form[action=?][method=?]', users_path, 'post' do
        assert_select 'input[name=?]', 'user[display_name]'
        assert_select 'input[name=?]', 'user[email]'
        assert_select 'input[name=?]', 'user[password]'
        assert_select 'input[name=?]', 'user[password_confirmation]'
        assert_select 'input[type=?]', 'submit'
      end
    end
  end

  describe 'POST /users' do
    let(:user_attributes) { FactoryBot.attributes_for(:user) }

    subject(:post_users) { post users_path, params: { user: user_attributes } }

    context 'with valid params' do
      it 'creates the user' do
        expect { post_users }.to change(User, :count).by(1)

        expect(User.last).to have_attributes user_attributes.except(:password, :password_confirmation)
      end

      it 'redirects to the homepage' do
        post_users

        expect(response).to redirect_to home_path
      end
    end

    context 'with invalid params' do
      let(:user_attributes) { super().merge(password: 'cat', password_confirmation: 'cat') }

      it 'does not create the user and displays the form with error messages' do
        expect { post_users }.not_to change(User, :count)

        expect(response).to have_http_status :unprocessable_entity
        assert_select 'form[action=?][method=?]', users_path, 'post' do
          assert_select 'p.is-danger', 'Password is too short (minimum is 8 characters)'
        end
      end
    end
  end
end
