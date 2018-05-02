# frozen_string_literal: true

module Requests
  module Sessions
    def sign_up(user_attributes: FactoryBot.attributes_for(:user))
      post users_path, params: { user: user_attributes }
    end
  end
end

RSpec.configure do |config|
  config.include Requests::Sessions, type: :request
end
