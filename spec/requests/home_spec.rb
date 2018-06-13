# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  describe 'GET /' do
    subject(:get_home) { get home_path }

    it 'has a link to the claim space flow' do
      get_home

      assert_select 'a[href=?]', new_group_path
    end

    context 'when a user is not logged in' do
      it 'navbar contains a link to login' do
        get_home

        assert_select 'nav' do
          assert_select 'a[href=?]', new_session_path, 'Login'
        end
      end
    end

    context 'when a user is logged in' do
      before { sign_up }

      it 'navbar contains a link to logout' do
        get_home

        assert_select 'nav' do
          assert_select 'form[action=?][method=?]', session_path, 'post' do
            assert_select 'input[type=?][name=?][value=?]', 'hidden', '_method', 'delete'
            assert_select 'input[type=?][value=?]', 'submit', 'Logout'
          end
        end
      end
    end
  end
end
