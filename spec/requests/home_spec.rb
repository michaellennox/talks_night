# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  describe 'GET /' do
    subject(:get_home) { get home_path }

    it 'has a link to the claim space flow' do
      get_home

      assert_select 'a[href=?]', new_group_path
    end
  end
end
