# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions resource', type: :request do
  describe 'GET /login' do
    subject(:get_login) { get new_session_path }

    it 'displays the form to create a new session' do
      get_login

      expect(response).to have_http_status :ok
      assert_select 'h1', 'Sign In'
      assert_select 'form[action=?][method=?]', sessions_path, 'post' do
        assert_select 'input[name=?]', 'email'
        assert_select 'input[name=?]', 'password'
        assert_select 'input[type=?]', 'submit'
      end
    end
  end

  describe 'POST /login' do
    let!(:user) { FactoryBot.create(:user) }
    let(:login_params) { { email: user.email, password: user.password } }

    subject(:post_login) { post sessions_path, params: login_params }

    context 'with valid parameters' do
      it 'logs the user in and redirects to home page' do
        post_login

        expect(session[:user_id]).to eq user.id
        expect(response).to redirect_to home_path
      end
    end

    shared_examples 'login failure' do
      it 'does not log in and displays that either username or password is incorrect' do
        post_login

        expect(session[:user_id]).to be nil
        expect(response).to have_http_status :unprocessable_entity
        assert_select 'form[action=?][method=?]', sessions_path, 'post'
        assert_select '.is-danger', 'Invalid username or password'
      end
    end

    context 'with an incorrect password' do
      let(:login_params) { super().merge(password: 'not-the-password') }

      include_examples 'login failure'
    end

    context 'with an incorrect username' do
      let(:login_params) { super().merge(email: 'not-user-email@example.com') }

      include_examples 'login failure'
    end
  end

  describe 'DELETE /logout' do
    before { sign_up }
    subject(:delete_logout) { delete session_path }

    it 'destroys the user\'s session and redirects to the homepage' do
      delete_logout

      expect(session[:user_id]).to eq nil
      expect(response).to redirect_to home_path
    end
  end
end
